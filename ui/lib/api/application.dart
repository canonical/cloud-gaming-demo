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

import 'dart:io';

class Application {
  static Map<String, String> appDesMap = const {
    'Beach Buggy Racing 2': 'Join the Beach Buggy Racing League and compete against drivers and cars from around the world. Race through Egyptian pyramids, dragon-infested castles, pirate ship wrecks, and experimental alien bio-labs. Collect and upgrade an arsenal of fun and wacky Powerups. Recruit new drivers, assemble a garage full of cars and race your way to the top of the League.',
  };

  String name = '';
  String background = '';
  String description = '';
  Application({required this.name, required this.background, this.description=''});

  factory Application.fromString(String name) {
    return Application(
      name: name,
      background: 'lib/assets/' + name + '.jpeg',
      description: appDesMap[name] ?? ""
    );
  }
}
