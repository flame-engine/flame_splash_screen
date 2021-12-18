part of flame_splash_screen;

/// This widget builds up the Flame logo composed of 3 layers,
/// that are rendered via separate PNG files under the assets directory.
class AnimatedLogo extends AnimatedWidget {
  /// Create this widget providing the animation parameter to control
  /// the opacity of the flame.
  const AnimatedLogo({
    Key? key,
    required Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/layer1.png',
          package: 'flame_splash_screen',
        ),
        Opacity(
          opacity: animation.value,
          child: Image.asset(
            'assets/layer2.png',
            package: 'flame_splash_screen',
          ),
        ),
        Image.asset(
          'assets/layer3.png',
          package: 'flame_splash_screen',
        ),
      ],
    );
  }
}

/// Creates and controls an [AnimatedLogo], making sure to provide the required
/// animation and to properly dispose of itself after usage.
class LogoComposite extends StatefulWidget {
  /// Creates a [LogoComposite].
  const LogoComposite({Key? key}) : super(key: key);

  @override
  _LogoCompositeState createState() => _LogoCompositeState();
}

class _LogoCompositeState extends State<LogoComposite>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);
}

Widget _logoBuilder(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return FractionalTranslation(
        translation: const Offset(0, -0.25),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(300, 300)),
          child: const LogoComposite(),
        ),
      );
    },
  );
}

/// Wraps the splash screen layout options
/// There is two predefined themes [FlameSplashTheme.dark] and [FlameSplashTheme.white]
class FlameSplashTheme {
  /// Creates a customized theme. [logoBuilder] returns the widget that will be
  /// rendered in place of main step of the animation.
  const FlameSplashTheme({
    required this.backgroundDecoration,
    required this.logoBuilder,
    this.constraints = const BoxConstraints.expand(),
  });

  /// Decoration to be applied to the widget underneath the Flame logo.
  /// It can be used to set the background colour, among other parameters.
  final BoxDecoration backgroundDecoration;

  /// A lambda to build the widget representing the logo itself.
  /// By default this will be wired to use the [LogoComposite] widget.
  final WidgetBuilder logoBuilder;

  /// Th constraints of the outside box, defaults to [BoxConstraints.expand].
  final BoxConstraints constraints;

  /// One of the two default themes provided; this is optimal of light mode
  /// apps.
  static FlameSplashTheme white = const FlameSplashTheme(
    backgroundDecoration: BoxDecoration(color: Color(0xFFFFFFFF)),
    logoBuilder: _logoBuilder,
  );

  /// One of the two default themes provided; this is optimal of dark mode apps.
  static FlameSplashTheme dark = const FlameSplashTheme(
    backgroundDecoration: BoxDecoration(color: Color(0xFF000000)),
    logoBuilder: _logoBuilder,
  );
}
