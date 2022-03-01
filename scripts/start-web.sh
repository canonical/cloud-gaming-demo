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

EXTRA_ARGS=

LISTEN_ADDRESS=$(snapctl get listen-address)
if [ -z "$LISTEN_ADDRESS" ]; then
    LISTEN_ADDRESS=0.0.0.0:8002
fi

if [ -e "$SNAP_COMMON"/tls/app.crt ] && [ -e "$SNAP_COMMON"/tls/app.key ]; then
    EXTRA_ARGS="$EXTRA_ARGS --keyfile $SNAP_COMMON/tls/app.key --certfile $SNAP_COMMON/tls/app.crt"
    EXTRA_ARGS="$EXTRA_ARGS --ssl-version=TLSv1_2"
fi

if [ -e "$SNAP_COMMON/tls/ca.crt" ]; then
    EXTRA_ARGS="$EXTA_ARGS --ca-certs $SNAP_COMMON/tls/ca.crt"
fi

export CONFIG_PATH="$SNAP_COMMON/service/config.yaml"

exec "$SNAP"/bin/talisker.gunicorn.gevent \
    --chdir "$SNAP" \
    --bind "$LISTEN_ADDRESS" \
    --worker-class gevent \
    $EXTRA_ARGS \
    service.service:app
