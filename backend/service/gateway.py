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

from typing import Union
from requests import Session

class GatwayAPI:
    def __init__(self, base_url: str, session: Session, token: str):
        self.base_url = base_url
        self.session = session
        self.token = token

    def make_request(
        self,
        method: str,
        path: str,
        headers: dict = {},
        data: Union[dict, bytes] = {},
    ):
        uri = f"{self.base_url}{path}"

        headers["Authorization"] = f"macaroon root={self.token}"
        headers["Content-Type"] = "application/json"

        return self.session.request(
            method, uri, json=data, headers=headers, verify=False
        )

    def create_session(self, data):
        uri = "/1.0/sessions"
        return self.make_request(
            "POST",
            uri,
            data=data,
            headers={"Content-Type": "application/json"},
        ).json()

    def get_applications(self):
        uri = "/1.0/applications/"
        return self.make_request("GET", uri).json()