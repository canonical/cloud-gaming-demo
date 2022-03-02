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


import 'package:cloud_gaming_demo/card.dart';
import 'package:flutter/material.dart';

class FeaturedApp extends StatelessWidget {
  final String name;
  final String backgroundUrl;
  final String description;

  const FeaturedApp(
      {Key? key, required this.name, required this.backgroundUrl, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool isLargeViewport = constraints.maxWidth >= 800;

        return Card(
          color: Colors.blueGrey.withOpacity(0.3),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            constraints: BoxConstraints(maxHeight: isLargeViewport ? 500 : 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: const Text("Featured game", style: TextStyle(color: Colors.white, fontSize: 32))
                ),
                Expanded(
                  child: Flex(
                    direction: isLargeViewport ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 3,
                          child: ApplicationCard(name: name, backgroundUrl: backgroundUrl, showPlayButton: false)
                      ),
                      Expanded(
                          flex: isLargeViewport ? 2 : 3,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(description, style: const TextStyle(fontSize: 16, color: Colors.white, letterSpacing: 1.2)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    Color(0xFF0D47A1),
                                                    Color(0xFF1976D2),
                                                    Color(0xFF42A5F5),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(20.0),
                                              primary: Colors.white,
                                              textStyle: const TextStyle(fontSize: 20),
                                            ),
                                            onPressed: () {},
                                            child: const Text('Play now'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
