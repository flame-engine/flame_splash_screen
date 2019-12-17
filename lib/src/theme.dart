part of flame_splash_screen;

/// Wraps the splash screen layout options
/// There is two predefined themes [FlameSplashTheme.dark] and [FlameSplashTheme.white]
class FlameSplashTheme {
  const FlameSplashTheme._(
      {this.backgroundDecoration, this.logo, this.constraints});

  final BoxDecoration backgroundDecoration;
  final String logo;
  final BoxConstraints constraints;

  static const FlameSplashTheme white = FlameSplashTheme._(
    backgroundDecoration: BoxDecoration(color: Color(0xFFFFFFFF)),
    logo: 'assets/flame-logo-white.gif',
    constraints: BoxConstraints.expand(),
  );

  static const FlameSplashTheme dark = FlameSplashTheme._(
    backgroundDecoration: BoxDecoration(color: Color(0xFF000000)),
    logo: 'assets/flame-logo-black.gif',
    constraints: BoxConstraints.expand(),
  );
}
