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

class Application {
  static Map<String, String> appDesMap = const {
    'bbr2': 'Join the Beach Buggy Racing League and compete against drivers and cars from around the world. Race through Egyptian pyramids, dragon-infested castles, pirate ship wrecks, and experimental alien bio-labs. Collect and upgrade an arsenal of fun and wacky Powerups. Recruit new drivers, assemble a garage full of cars and race your way to the top of the League.',
    'bombsquad': 'Blow up your friends in mini-games ranging from capture-the-flag to hockey! Featuring 8 player local/networked multiplayer, gratuitous explosions, advanced ragdoll face-plant physics, pirates, ninjas, barbarians, insane chefs, and more.',
    'mindustry': 'Mindustry is a hybrid tower-defense sandbox factory game. Create elaborate supply chains of conveyor belts to feed ammo into your turrets, produce materials to use for building, and defend your structures from waves of enemies.',
    'minetest': 'An open source voxel game engine. Play one of our many games, mod a game to your liking, make your own game, or play on a multiplayer server.'
  };

  static Map<String, String> appNameMap = const {
    'bbr2': 'Beach Buggy Racing 2',
    'bombsquad': 'BombSquad',
    'mindustry': 'Mindustry',
    'minetest': 'Minetest'
  };

  String id = '';
  String name = '';
  String background = '';
  String description = '';
  Application({required this.id, required this.name, required this.background, this.description=''});

  factory Application.fromString(String id) {
    return Application(
      id: id,
      name: appNameMap[id] ?? "",
      background: 'lib/assets/' + id + '.jpeg',
      description: appDesMap[id] ?? ""
    );
  }
}
