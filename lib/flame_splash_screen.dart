library flame_splash_screen;

import 'package:flutter/material.dart';

class FlameSplashScreenWidget extends StatefulWidget {
  final bool darkTheme;
  final Duration fadeInDuration;
  final Duration waitDuration;
  final Duration fadeOutDuration;

  final String navigateTo;

  FlameSplashScreenWidget({
    @required this.navigateTo,
    this.darkTheme = false,
    this.fadeInDuration = const Duration(seconds: 1),
    this.waitDuration = const Duration(seconds: 1),
    this.fadeOutDuration = const Duration(seconds: 1),
  });

  @override
  State<StatefulWidget> createState() => _FlameSplashScreenWidgetState();
}

class _FlameSplashScreenWidgetState extends State<FlameSplashScreenWidget> {

  bool _visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.waitDuration).then((_) {
      setState(() {
        _visible = true;
      });

      Future.delayed(widget.fadeInDuration).then((_) {
        setState(() {
          _visible = false;
        });
      });
    });

    Future.delayed(
        widget.waitDuration +
        widget.fadeInDuration +
        widget.fadeOutDuration
    ).then((_) {
      Navigator.of(context).pushReplacementNamed(widget.navigateTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: widget.darkTheme ? Color(0xFF000000) : Color(0xFFFFFFFF),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  duration: widget.fadeInDuration,
                  child: Image(
                      width: 300,
                      image: AssetImage(
                          'assets/flame-logo-${widget.darkTheme ? 'black' : 'white'}.gif',
                          package: 'flame_splash_screen'
                      )
                  ),
              ),
            ]
        ));
  }
}
