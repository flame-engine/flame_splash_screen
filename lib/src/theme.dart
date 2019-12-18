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
  /// Creates a customized theme. [logoBuilder] returns the widget that will be
  /// rendered in place of main step of the animation.
  const FlameSplashTheme({
    @required this.backgroundDecoration,
    @required this.logoBuilder,
    this.constraints = const BoxConstraints.expand(),
  });

  final BoxDecoration backgroundDecoration;
  final WidgetBuilder logoBuilder;

  /// Th constraints of the outside box, defaults to [BoxConstraints.expand].
  final BoxConstraints constraints;

  static FlameSplashTheme white = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
    logoBuilder: _whiteLogoBuilder,
  );

  static FlameSplashTheme dark = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFF000000)),
    logoBuilder: _darkLogoBuilder,
  );
}
