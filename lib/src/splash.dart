part of flame_splash_screen;

/// A stateful widget to show a splash screen animation for flame games
class FlameSplashScreen extends StatefulWidget {
  /// Creates a [FlameSplashScreen].
  const FlameSplashScreen({
    Key? key,
    required this.onFinish,
    required this.theme,
    this.showBefore,
    this.showAfter,
    this.controller,
  }) : super(key: key);

  /// Gives extra controller over the splash animation.
  final FlameSplashController? controller;

  /// Enables to set a different theme other than the default.
  final FlameSplashTheme theme;

  /// The only required option, callback to be invoked when animation finished
  final ValueChanged<BuildContext> onFinish;

  /// Adds an extra step to the animation showing a widget, can be other logo.
  ///
  /// Shown before flame logo.
  final WidgetBuilder? showBefore;

  /// Adds an extra step to the animation showing a widget, can be other logo.
  ///
  /// Shown after flame logo.
  final WidgetBuilder? showAfter;

  @override
  _FlameSplashScreenState createState() => _FlameSplashScreenState();
}

class _FlameSplashScreenState extends State<FlameSplashScreen> {
  bool _externallyControlled = false;
  late FlameSplashController controller;
  late List<WidgetBuilder> steps;

  @override
  void initState() {
    super.initState();

    _externallyControlled = widget.controller != null;
    controller = widget.controller ?? FlameSplashController();

    computeSteps();
    controller.setup(steps.length, onFinish);
  }

  void computeSteps() {
    setState(() {
      steps = [
        if (widget.showBefore != null) widget.showBefore!,
        widget.theme.logoBuilder,
        if (widget.showAfter != null) widget.showAfter!,
      ];
    });
  }

  void onFinish() {
    widget.onFinish(context);
  }

  @override
  void didUpdateWidget(FlameSplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasStepsChanged = widget.showBefore != oldWidget.showBefore ||
        widget.showAfter != oldWidget.showAfter ||
        widget.theme.logoBuilder != oldWidget.theme.logoBuilder;
    if (hasStepsChanged &&
        controller._state != FlameSplashControllerState.started) {
      computeSteps();
      controller.start();
    }
  }

  @override
  void dispose() {
    if (!_externallyControlled) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.theme.constraints,
      decoration: widget.theme.backgroundDecoration,
      child: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: controller._stepController,
          builder: (context, currentStep, _) {
            return _SplashScreenStep(
              builder: steps[currentStep],
              durations: controller._durations,
              key: ObjectKey(currentStep),
            );
          },
        ),
      ),
    );
  }
}

class _SplashScreenStep extends StatefulWidget {
  const _SplashScreenStep({
    Key? key,
    required this.builder,
    required this.durations,
  }) : super(key: key);

  final WidgetBuilder builder;
  final _FlameSplashDurations durations;

  @override
  __SplashScreenStepState createState() => __SplashScreenStepState();
}

class __SplashScreenStepState extends State<_SplashScreenStep>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
    )..addListener(handleAnimation);
    opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);
    startAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleAnimation() {
    setState(() {
      opacity = opacityAnimation.value;
    });
  }

  void startAnimation() async {
    // fade in
    controller
      ..value = 0.0
      ..duration = widget.durations.fadeInDuration;
    await controller.forward();
    await Future<void>.delayed(widget.durations.waitDuration);
    controller
      ..value = 1.0
      ..duration = widget.durations.fadeOutDuration
      ..reverse();
  }

  @override
  void didUpdateWidget(_SplashScreenStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.key != widget.key) {
      startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: widget.builder(context),
    );
  }
}
