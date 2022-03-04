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

import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  final String name;
  final String backgroundUrl;
  final bool showPlayButton;
  final Function() onPlay;

  const ApplicationCard({
    Key? key,
    required this.name,
    required this.backgroundUrl,
    this.showPlayButton=true,
    required this.onPlay
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Card(
            semanticContainer: true,
            color: Colors.black26,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 5,
            child: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Image(
                        image: AssetImage(backgroundUrl),
                        fit: BoxFit.cover,
                        alignment: const Alignment(-1.0, -1.0),
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
                              if (showPlayButton) IconButton(
                                color: Colors.white70,
                                icon: const Icon(Icons.play_circle_outline),
                                tooltip: 'Play $name',
                                onPressed: onPlay,
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
