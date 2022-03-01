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

from flask import Flask, jsonify
from requests import Session
from requests.adapters import HTTPAdapter
from urllib3 import Retry

from service import config
from service.gateway import GatwayAPI


app = Flask(__name__)

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

gateway = GatwayAPI(
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

    return jsonify({}), 200

@app.route('/1.0/games', methods=['GET'])
def api_1_0_games_get():
    if not gateway_enabled:
        return render_error_response("no gateway connected", 503)

    return jsonify({}), 200
