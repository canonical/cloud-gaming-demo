//
// Copyright 2022 Canonical Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import 'package:js/js.dart';

@JS('AnboxStreamGatewayConnector')
class GatewayConnector {
  external GatewayConnector(ConnectorOptions options);
}

@JS()
@anonymous
class ConnectorOptions {
  external factory ConnectorOptions({
    String url,
    String authToken,
    Screen screen,
    Session session
  });
}

@JS()
@anonymous
class Screen {
  external factory Screen({
    int width,
    int height,
    int fps,
    int density
  });
}

@JS()
@anonymous
class Session {
  external factory Session({
    String region,
    String id,
    String app,
    int app_version,
    bool joinable,
    int idle_time_min
  });
}