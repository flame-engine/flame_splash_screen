import 'package:flutter/material.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlameSplashScreenWidget(navigateTo: '/game'),
      routes: {
        '/game': (context) => AwesomeGame()
      }
    );
  }
}

class AwesomeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Insert an awesome game here!")
            ]
        )
    );
  }
}
