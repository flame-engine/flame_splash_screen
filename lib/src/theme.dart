part of flame_splash_screen;

WidgetBuilder _whiteLogoBuilder = (context) => Image(
  width: 300,
  image: const AssetImage(
    'assets/flame-logo-white.gif',
    package: 'flame_splash_screen',
  ),
);


WidgetBuilder _darkLogoBuilder = (context) => Image(
  width: 300,
  image: const AssetImage(
    'assets/flame-logo-black.gif',
    package: 'flame_splash_screen',
  ),
);

/// Wraps the splash screen layout options
/// There is two predefined themes [FlameSplashTheme.dark] and [FlameSplashTheme.white]
class FlameSplashTheme {
  const FlameSplashTheme({
    @required this.backgroundDecoration,
    @required this.mainStep,
    this.constraints = const BoxConstraints.expand(),
  });

  final BoxDecoration backgroundDecoration;
  final WidgetBuilder mainStep;

  /// Th constraints of the outside box, defaults to [BoxConstraints.expand].
  final BoxConstraints constraints;

  static FlameSplashTheme white = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
    mainStep: _whiteLogoBuilder,
  );

  static FlameSplashTheme dark = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFF000000)),
    mainStep: _darkLogoBuilder,
  );
}
