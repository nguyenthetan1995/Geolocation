import 'package:flutter/material.dart';
import 'map.dart';

import 'package:latlong/latlong.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: new Scaffold(
        appBar: new AppBar(
          title: Text(''),
        ),
        body: new map()
      )
    );
  }


}


