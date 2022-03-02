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

import 'package:cloud_gaming_demo/api/application.dart';
import 'package:cloud_gaming_demo/app_list.dart';
import 'package:cloud_gaming_demo/featured.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CloudGamingDemo());
}

class CloudGamingDemo extends StatelessWidget {
  const CloudGamingDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anbox Cloud - Cloud Gaming Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    List<Application> apps = [
      Application(name: 'Beach Buggy Racing 2', background: 'lib/assets/beachbuggy2_bg.jpeg', description: 'Join the Beach Buggy Racing League and compete against drivers and cars from around the world. Race through Egyptian pyramids, dragon-infested castles, pirate ship wrecks, and experimental alien bio-labs. Collect and upgrade an arsenal of fun and wacky Powerups. Recruit new drivers, assemble a garage full of cars and race your way to the top of the League.'),
      Application(name: 'Bombsquad', background: 'lib/assets/bombsquad_bg.jpeg'),
    ];

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
          backgroundColor: const Color(0xff191d26),
          body: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.0, 0.5],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: <Color>[
                      Color(0xFF384661),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child:
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    constraints: const BoxConstraints(maxWidth: 1100),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        FeaturedApp(name: apps[0].name, backgroundUrl: apps[0].background, description: apps[0].description),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: const Text(
                                  'Available applications',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppList(apps: apps)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
