#!/bin/bash -e
#
# Copyright 2022 Canonical Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: please run this script as root"
    exit 1
fi

if ! snap list | grep -q anbox-cloud-appliance; then
  echo "ERROR: Anbox Cloud Appliance not installed"
  exit 1
fi

LOCAL_SNAP=
CHANNEL=latest/stable
SERVICE_NAME=cloud-gaming-demo
DEMO_SNAP_COMMON_DIR="/var/snap/cloud-gaming-demo/common"
APPLIANCE_SNAP_COMMON_DIR="/var/snap/anbox-cloud-appliance/common"

GAMES="bombsquad mindustry"
BOMBSQUAD_DOWNLOAD_URL="https://files.ballistica.net/bombsquad/builds/BombSquad_Android_Generic_1.6.10.apk"
BOMBSQUAD_PKG_ARCH="universal"
MINDUSTRY_DOWNLOAD_URL="https://f-droid.org/repo/io.anuke.mindustry_104.apk"
MINDUSTRY_PKG_ARCH="universal"

print_help() {
    echo "Usage: ${0} [OPTIONS]"
    echo "       install and configure cloud gaming demo to make it work against an Anbox Cloud Appliance deployment"
    echo
    echo "arguments:"
    echo " --local-snap=<string>             Path to the local snap for cloud gaming demo installation"
    echo " --channel=<string>                Channel the snap to track and be installed from the store"
    echo " -h|--help                         Show help"
}


while [ -n "$1" ]; do
    case "$1" in
        --local-snap=*)
            LOCAL_SNAP=${1#*=}
            shift
            ;;
        --channel=*)
            CHANNEL=${1#*=}
            shift
            ;;
        -h|--help)
            print_help
            exit 2
            ;;
        *)
            echo "ERROR: Unsupported argument: $1"
            exit 1
            ;;
    esac
done

set -x

generate_config_file() {
  local gateway_address="$1"
  # Due to a bug(AC-777), use the juju command to create a gateway token
  # rather than using anbox-cloud-appliance.
  local token=$(sudo -u ubuntu juju ssh -m appliance:anbox-cloud anbox-stream-gateway/0 \
                -- "sudo /snap/bin/anbox-stream-gateway account create cloud-gaming-demo-$(date +%s)")

  local service_folder="${DEMO_SNAP_COMMON_DIR}/service"
  mkdir -p "${service_folder}" && chmod 0750 "${service_folder}"
  cat << EOF > "${service_folder}/config.yaml"
gateway-url: https://${gateway_address}
gateway-token: ${token}
EOF

  chmod -R 0600 "${service_folder}/config.yaml"
}

install_snap() {
  local channel=$1
  local snap_path=$2

  if snap list | grep cloud-gaming-demo ; then
    snap remove --purge cloud-gaming-demo
  fi

  if [ -n "${snap_path}" ];  then
    echo "Install cloud gaming demo from the local snap..."
    snap install --dangerous "${snap_path}"
  else
    echo "Install cloud gaming demo from the snap store..."
    snap install cloud-gaming-demo --channel="${channel}"
  fi
}

install_games() {
  local work_dir=$1
  local instance_type="g4.3"
  if sudo -u ubuntu amc node show lxd0 | grep "gpus: {}" > /dev/null; then
    instance_type="a4.3"
  fi

  chown -R ubuntu:ubuntu "${work_dir}"

  host_arch=$(dpkg-architecture -qDEB_HOST_ARCH)
  # Do not install the application in parallel since we may run the risk for
  # application installation and fail the entire installation process due to
  # lack of system resources for AMS to create base containers if the appliance
  # is installed in a small instance.
  for game in ${GAMES[@]}; do
    echo "Installing $game..."
    if sudo -u ubuntu amc application ls | grep "${game}.*ready"; then
      echo "$game" >> "${work_dir}/.installed_games"
      continue;
    fi

    local pkg_arch="${game^^}_PKG_ARCH"
    if [ "${!pkg_arch}" != "universal" ] &&
         [ "${!pkg_arch}" != "$host_arch" ] ; then
      continue;
    fi

    local app_dir="${work_dir}/${game}"
    mkdir -p "${app_dir}" && chown -R ubuntu:ubuntu "${work_dir}"
    local download_url="${game^^}_DOWNLOAD_URL"
    wget "${!download_url}" -O "${app_dir}/app.apk"
    cat << EOF > "${app_dir}"/manifest.yaml
name: $game
instance-type: $instance_type
EOF
    chown -R ubuntu:ubuntu "${app_dir}"
    sudo -u ubuntu amc application create "${app_dir}"
    sudo -u ubuntu amc wait -c status=ready "${game}"

    echo "$game" >> "${work_dir}/.installed_games"
  done
}

configure_routes() {
  local service_address=$1

  cat << EOF > cloud-gaming-demo.yaml
http:
  routers:
    to-cloud-gaming-demo:
      entryPoints: ["websecure"]
      rule: "PathPrefix(\`/demo/\`)"
      service: cloud-gaming-demo
      priority: 110
      tls: {}
      middlewares: ["ratelimiter", "strip-demo-prefix"]
  middlewares:
    strip-demo-prefix:
      stripPrefix:
        prefixes:
          - "/demo"
        forceSlash: false

  services:
    cloud-gaming-demo:
      loadBalancer:
        servers:
          - url: http://$service_address
EOF

  mv cloud-gaming-demo.yaml "${APPLIANCE_SNAP_COMMON_DIR}"/traefik/conf/
  chmod 0600 "${APPLIANCE_SNAP_COMMON_DIR}"/traefik/conf/cloud-gaming-demo.yaml
}

configure_demo_service() {
  local service_address=$1
  sudo snap set cloud-gaming-demo listen-address="${service_address}"
  snap restart cloud-gaming-demo
}

generate_uninstall_script() {
  local work_dir=$1

  cat << EOF > uninstall.sh
#!/bin/bash -e
#
# Copyright 2022 Canonical Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ "\$(id -u)" -ne 0 ]; then
  echo "ERROR: please run this script as root"
  exit 1
fi

snap remove --purge cloud-gaming-demo
rm "${APPLIANCE_SNAP_COMMON_DIR}/traefik/conf/cloud-gaming-demo.yaml"

games="$(echo $(cat ${work_dir}/.installed_games))"
for game in \$games; do
  echo "Uninstalling \$game..."
  sudo -u ubuntu amc application delete \$game -y
done
EOF
  chmod u+x uninstall.sh
}

work_dir=$(mktemp -p "$PWD" -d app.XXXXXXX)
trap "rm -fr $work_dir" EXIT INT

eval "$(anbox-cloud-appliance internal generate-cloud-info)"
demo_address="0.0.0.0:8002"

install_snap "${CHANNEL}" "${LOCAL_SNAP}"

install_games "${work_dir}"

generate_config_file "${CLOUD_PUBLIC_LOCATION}"

configure_routes "${demo_address}"

configure_demo_service "${demo_address}"

generate_uninstall_script "${work_dir}"

echo "Cloud gaming demo service serve at: https://${CLOUD_PUBLIC_LOCATION}/demo/"
