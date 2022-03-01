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
import 'package:flutter/material.dart';

void main() {
  runApp(const CloudGamingDemo());
}

class CloudGamingDemo extends StatelessWidget {
  const CloudGamingDemo({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
      Application(name: 'Beach Buggy Racing 2', background: 'lib/assets/beachbuggy2_bg.jpeg'),
      Application(name: 'Bombsquad', background: 'lib/assets/bombsquad_bg.jpeg')
    ];
    List<Widget> gameCards = [];

    for (var app in apps) {
      gameCards.add(
        SizedBox(
          height: 300,
          width: 600,
          child: ApplicationCard(name: app.name, backgroundUrl: app.background),
        )
      );
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Available applications'),
            ...gameCards,
          ],
        ),
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final String name;
  final String backgroundUrl;
  const ApplicationCard({Key? key, required this.name, required this.backgroundUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Stack(
        children: <Widget>[
          Card(
            semanticContainer: true,
            color: Colors.black26,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            elevation: 5,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Image(
                      image: AssetImage(backgroundUrl),
                      fit: BoxFit.cover,
                      alignment: const Alignment(1.0, -1.0),
                  )
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: SizedBox.expand(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )
                              ),
                            IconButton(
                              color: Colors.white70,
                              icon: const Icon(Icons.play_circle_outline),
                              tooltip: 'Play $name',
                              onPressed: () {},
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ]
            ),
          ),
        ]
      );
  }
}
