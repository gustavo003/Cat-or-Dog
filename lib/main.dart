import 'package:catordog/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gato ou cachorro',
      theme: _buildTheme(),
      home: HomePage(),
    );
  }

  _buildTheme() {
    return ThemeData(
      primaryColor: Color(0xFF212121),

    );
  }
}

