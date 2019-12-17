import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flame_splash_screen/flame_splash_screen.dart';

void main() {
  test('white', () {
    final theme = FlameSplashTheme.white;
    expect(theme.constraints, BoxConstraints.expand());
    expect(theme.backgroundDecoration,
        BoxDecoration(color: const Color(0xFFFFFFFF)));
    expect(theme.logo, 'assets/flame-logo-white.gif');
  });

  test('dark', () {
    final theme = FlameSplashTheme.dark;
    expect(theme.constraints, BoxConstraints.expand());
    expect(theme.backgroundDecoration,
        BoxDecoration(color: const Color(0xFF000000)));
    expect(theme.logo, 'assets/flame-logo-black.gif');
  });
}
