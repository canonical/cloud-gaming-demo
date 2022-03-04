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

import 'package:cloud_gaming_demo/sdk/connector.dart';
import 'package:js/js.dart';

@JS('window.AnboxStream')
class AnboxStream {
  external AnboxStream(AnboxStreamOptions options);
  external void connect();
  external void disconnect();
  external void requestFullscreen();
}

@JS()
@anonymous
class AnboxStreamOptions {
  external factory AnboxStreamOptions({
    GatewayConnector connector,
    String targetElement,
    bool fullscreen,
    String deviceType,
    List<StunServer> stunServers,
    Devices devices,
    Controls controls,
  });
}

@JS()
@anonymous
class StunServer {
  external factory StunServer({
    List<String> urls,
    String username,
    String password,
  });
}

@JS()
@anonymous
class Devices {
  external factory Devices({
    bool microphone,
    bool camera,
    bool speaker,
  });
}

@JS()
@anonymous
class Controls {
  external factory Controls({
    bool keyboard,
    bool mouse,
    bool gamepad
  });
}
// TODO: callbacks