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

from re import I
from flask import Flask, jsonify, request
from requests import Session
from requests.adapters import HTTPAdapter
from urllib3 import Retry

from service import config
from service.gateway import GatewayAPI

app = Flask(
    __name__,
    static_folder="./static",
)

retry_strategy = Retry(
    total=3,
    backoff_factor=1,
    method_whitelist=["HEAD", "GET", "OPTIONS"]
)
adapter = HTTPAdapter(max_retries=retry_strategy)
internal_session = Session()
internal_session.mount("https://", adapter)
internal_session.mount("http://", adapter)

gateway_api_url = config.get("gateway-url", None)
gateway_api_token = config.get("gateway-token", None)
gateway_enabled = bool(gateway_api_url and gateway_api_token)

gateway = GatewayAPI(
    gateway_api_url,
    internal_session,
    gateway_api_token
)


def render_error_response(msg, code):
    resp = {"error_msg": msg}
    return jsonify(resp), code


@app.route('/1.0/sessions/', methods=['POST'])
def api_1_0_sessions_post():
    if not gateway_enabled:
        return render_error_response("no gateway connected", 503)

    data = request.json
    if not data:
        return render_error_response("invalid input", 400)

    if not 'game' in data or len(data['game']) == 0:
        return render_error_response("invalid game selected", 400)

    req = {
        "app": data['game'],
        "joinable": False,
        "screen": {
            "width": 1280,
            "height": 720,
            "fps": 60,
        }
    }

    resp = gateway.create_session(req)

    if not 'status_code' in resp or resp['status_code'] != 201:
        return render_error_response("failed to create session", 500)

    return jsonify(resp["metadata"]), 200


@app.route('/1.0/games', methods=['GET'])
def api_1_0_games_get():
    if not gateway_enabled:
        return render_error_response("no gateway connected", 503)

    resp = gateway.get_applications()

    if not 'status_code' in resp or resp['status_code'] != 200:
        return render_error_response("failed to communicate with gateway", 500)

    if not 'metadata' in resp:
        return render_error_response("received invalid response from gateway", 500)

    metadata = resp['metadata']
    apps = []
    for app in metadata:
        if not 'name' in app:
            continue
        apps.append(app['name'])

    return jsonify(apps), 200


@app.route('/')
def root_file():
    return app.send_static_file('index.html')

@app.route('/<path:filename>')
def static_file(filename):
    return app.send_static_file(filename)
