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

import 'dart:convert';
import 'dart:js';

import 'package:cloud_gaming_demo/homepage.dart';
import 'package:cloud_gaming_demo/sdk/sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart' as http;
import 'package:js/js_util.dart' as js;
import 'dart:io';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const CloudGamingDemo());
}

Future<JsObject> createSession(String game) async {
  final url = Uri.parse(Uri.base.toString() + '1.0/sessions/');
  final body = json.encode({'game': game});
  Map<String,String> headers = {
    'Content-type' : 'application/json',
  };

  final response = await http.post(url, body: body, headers: headers);
  if (response.statusCode == 200) {
    final metadata = jsonDecode(response.body);
    Map<String, dynamic> sessionInfo = {
      'id': metadata['id'],
      'websocket': metadata['url'],
      'stunServers': metadata['stun_servers']
    };
    return JsObject.jsify(sessionInfo);
  } else {
    throw HttpException('Failed to create session');
  }
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
  startStreaming(String game) {
  }

  @override
  Widget build(BuildContext buildContext) {
    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: const Color(0xff191d26),
          body: Homepage(onPlay: (String game) {
            // FIXME: ideally, we should call the createSession function
            //        in the connector.connect JS function, so the connector
            //        can fetch the sesssion info from the backend on demand.
            //        However since the Future<T> is not primitive type,
            //        returning Future<T> type leads to a DartObject JS
            //        object received on the JS SDK side and fails in
            //        parsing session info. Hence we should always give
            //        a JsObject rather than Future<JsObject> back from
            //        dart to JS side.
            createSession(game).then((JsObject sessionInfo) {
              Map<String, dynamic> options = {
                'targetElement': 'anbox-cloud-stream',
                'fullscreen': true,
                'connector': {
                  'connect': () { return sessionInfo; },
                  'disconnect': () {}
                }
              };

              var stream = JsObject(context['AnboxStream'], [JsObject.jsify(options)]);
              stream.callMethod('connect', []);
              stream.callMethod('requestFullscreen', []);

              void fullScreenChangedCallback(JsObject ev) {
                var doc = JsObject.fromBrowserObject(context['document']);
                if(!doc['webkitIsFullScreen'] &&
                   !doc['fullscreenchange'] &&
                   !doc['mozfullscreenchange']){
                    stream.callMethod('disconnect', []);
                }
              }

              var cb = allowInterop(fullScreenChangedCallback);
              var window = JsObject.fromBrowserObject(context['window']);
              window.callMethod('addEventListener', ['fullscreenchange', cb]);
            }).catchError((e) {
              final scaffold = ScaffoldMessenger.of(buildContext);
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('${e.message}'),
              ));
            });
          }),
        );
      }
    );
  }
}
