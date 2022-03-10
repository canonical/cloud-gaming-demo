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

import 'api/application.dart';
import 'card.dart';

class AppList extends StatelessWidget {
  final List<Application> apps;
  final Function(String id) onPlay;

  const AppList({Key? key, required this.apps, required this.onPlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool isLargeViewport = constraints.maxWidth >= 800;

          return Column(
            children: [
              Wrap(
                children: [
                  for (var app in apps) Container(
                    margin: const EdgeInsets.all(10),
                    constraints: isLargeViewport ? const BoxConstraints(maxWidth: 330, maxHeight: 200) : const BoxConstraints(maxHeight: 300),
                    child: ApplicationCard(
                      id: app.id,
                      name: app.name,
                      backgroundUrl: app.background,
                      onPlay: onPlay,
                    ),
                  )
                ],
              ),
            ],
          );
        }
    );
  }
}
