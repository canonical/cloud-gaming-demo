# Cloud gaming demo for Anbox Cloud

This project demonstrates a simple cloud gaming service on top of [Anbox Cloud](https://anbox-cloud.io)
that allows users to play Android-based games right from their web browser on any device.

## Overview

The demo consists of two components:

* A backend service written in [Python](https://www.python.org/)
* A web UI based on [Flutter](https://flutter.dev/)

The backend service connects to the Anbox Cloud services and retrieves a list of available applications.
It also takes care of launching the actual streaming sessions on demand.

Inside the web UI, the user can choose from the list of available games and start playing either of them.

![Cloud Gaming Demo UI](docs/screenshot.png)

## How to install

To run the demo, simply complete the following steps:

1. Install the Anbox Cloud Appliance. See the [documentation](https://anbox-cloud.io/docs/tut/installing-appliance) for instructions.
2. SSH to your appliance instance, clone the demo repository and run the installation script:

    ```
    git clone git://github.com/anbox-cloud/cloud-gaming-demo
    cd cloud-gaming-demo
    sudo scripts/install.sh
    ```

The installation takes some time because it fetches and installs a selection of freely available Android
game titles.

At the end, the installation script prints the URL where you can access the demo. Happy gaming!

## How to uninstall

If you don't want to use the cloud gaming demo any longer, simply uninstall it from
your Anbox Cloud Appliance by running the following commands:

    cd cloud-gaming-demo
    sudo ./uninstall.sh

This script removes the cloud gaming demo and all its configuration from the machine.

## Secure access via HTTP basic auth

By default, the demo is exposed without access control. However, you can easily add basic HTTP authentication by adding a middleware definition (see [BasicAuth](https://doc.traefik.io/traefik/v2.0/middlewares/basicauth/) for more details) to the [traefik](https://traefik.io/) configuration at `/var/snap/anbox-cloud-appliance/common/traefik/conf/cloud-gaming-demo.yaml`.

First, use the `htpasswd` tool to generate a user/password combination:

    apt install -y apache2-utils
    httpasswd -n <your user name>

Enter your desired password when prompted. Then insert the printed user/hashed password combination into the traefik configuration by opening `/var/snap/anbox-cloud-appliance/common/traefik/conf/cloud-gaming-demo.yaml`
in an editor and changing the configuration to look like:

    http:
    routers:
        ...
        middlewares: ["ratelimiter", "strip-demo-prefix", "demo-auth"]
    middlewares:
        ...
        demo-auth:
            basicAuth:
                users:
                - "<user name>:<hashed password>"
    ...

Afterwards, every user will be asked for a user name and password when accessing the demo site.

## How to build a snap

If you want to build the [snap package](https://snapcraft.io) including the demo UI and service yourself,
install the [snapcraft](https://snapcraft.io) build tool. See the [Snapcraft documentation](https://snapcraft.io/docs/snapcraft-overview) for instructions.

When you have snapcraft installed, run the following command in the root directory of the repository to build the snap:

    snapcraft

This will start the build process and produce a `.snap` package that you can install with the following command:

    snap install --dangerous cloud-gaming-demo*.snap

## Used games

The demo currently uses the following games:

 * [BombSquad](http://www.bombsquadgame.com/)
 * [Mindustry](https://github.com/Anuken/Mindustry)

## Get help & community

If you get stuck deploying the demo or would like some help with Anbox Cloud in general, come and ask on the [Anbox Cloud discourse forum](https://discourse.ubuntu.com/c/anbox-cloud)!

## More information

You can find more information about Anbox Cloud on the [website](https://anbox-cloud.io) and in the
[documentation](https://anbox-cloud.io/docs).

If you're interested in building a real production cloud gaming service, [get in touch](https://anbox-cloud.io/contact-us)!