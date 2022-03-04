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

import 'package:cloud_gaming_demo/homepage.dart';
import 'package:cloud_gaming_demo/sdk/connector.dart';
import 'package:cloud_gaming_demo/sdk/sdk.dart';
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
  startStreaming() {
    var connector = GatewayConnector(ConnectorOptions(
        url: 'https://anbox.example.com',
        authToken: 'INSERT GATEWAY HERE',
        session: Session(app: 'com.bar.foo')
    ));

    var stream = AnboxStream(AnboxStreamOptions(
      connector: connector,
      targetElement: "anbox-cloud-stream",
      fullscreen: true,
    ));

    stream.connect();
    stream.requestFullscreen();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: const Color(0xff191d26),
          body: Homepage(onPlay: startStreaming),
        );
      }
    );
  }
}
