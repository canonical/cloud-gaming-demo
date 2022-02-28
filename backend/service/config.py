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

import os
import yaml

class Throw:
    pass

def load_config(path=None):
    if not path and os.getenv("SNAP_COMMON"):
        path = "{}/service/config.yaml".format(os.getenv("SNAP_COMMON"))

    if not path:
        return {}

    with open(path, "r") as config_file:
        return yaml.load(config_file, Loader=yaml.Loader)

def get(key, default=Throw):
    if key in _cfg:
        return _cfg[key]

    if default == Throw:
        raise Exception(f"Configuration option '{key}' not present")

    return default

path = os.getenv("CONFIG_PATH")
_cfg = load_config(path)