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
import 'dart:async';
import 'dart:convert';

import 'package:cloud_gaming_demo/api/application.dart';
import 'package:cloud_gaming_demo/app_list.dart';
import 'package:cloud_gaming_demo/featured.dart';
import 'package:cloud_gaming_demo/exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Application>> fetchApps(List<String> ids) async {
  final response = await http
      .get(Uri.parse(Uri.base.toString() + "1.0/games"));
  if (response.statusCode == 200) {
    List<String> applist = jsonDecode(response.body).where((i) => ids.contains(i));
    return List<Application>.from(applist.map((v) => Application.fromString(v)));
  } else {
    throw HttpException('Failed to load games');
  }
}

class Homepage extends StatefulWidget {
  final Function(String id) onPlay;

  const Homepage({Key? key, required this.onPlay}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();

}

class _HomepageState extends State<Homepage> {
  late Future<List<Application>> futureApps;
  final gameids = ['bombsquad', 'bbr2', 'mindustry', 'minetest'];

  @override
  void initState() {
    super.initState();
    futureApps = fetchApps(gameids);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
            child: FutureBuilder<List<Application>>(
              future: futureApps,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final apps = snapshot.data;

                  if(apps!.isEmpty) {
                    return const NoAppsPlaceholder();
                  }

                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    constraints: const BoxConstraints(maxWidth: 1100),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        FeaturedApp(
                          id: apps[0].id,
                          name: apps[0].name,
                          backgroundUrl: apps[0].background,
                          description: apps[0].description,
                          onPlay: widget.onPlay
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: const Text(
                                  'Available games',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppList(apps: apps, onPlay: widget.onPlay)
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    alignment: Alignment.center,
                    child: Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        )
                      )
                    );
                }
                return const CircularProgressIndicator();
              },
            )
          ),
        )
      ],
    );
  }
}

class NoAppsPlaceholder extends StatelessWidget {
  const NoAppsPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
      alignment: Alignment.center,
      child: const Text(
          'No game available',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
          )
      )
    );
  }

}