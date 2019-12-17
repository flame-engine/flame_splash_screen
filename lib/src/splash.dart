part of flame_splash_screen;

class FlameSplashScreen extends StatefulWidget {
  const FlameSplashScreen({
    Key key,
    @required this.onFinish,
    this.theme = FlameSplashTheme.dark,
    this.showBefore,
    this.showAfter,
    this.controller,
  })  : assert(onFinish != null, 'You have to pass an `onFinish` callback.'),
        super(key: key);

  final FlameSplashController controller;
  final FlameSplashTheme theme;
  final ValueChanged<BuildContext> onFinish;
  final WidgetBuilder showBefore;
  final WidgetBuilder showAfter;

  @override
  _FlameSplashScreenState createState() => _FlameSplashScreenState();
}

class _FlameSplashScreenState extends State<FlameSplashScreen> {
  bool _externallyControlled = false;
  FlameSplashController controller;
  List<WidgetBuilder> steps;

  @override
  void initState() {
    super.initState();

    _externallyControlled = widget.controller != null;
    controller = widget.controller ?? FlameSplashController();

    computeSteps();
    controller.setup(steps.length, onFinish);
  }

  void computeSteps() {
    steps = [buildMainLogo];
    if (widget.showBefore != null) {
      steps.insert(0, widget.showBefore);
    }
    if (widget.showAfter != null) {
      steps.add(widget.showAfter);
    }
    setState(() {});
  }

  void onFinish() {
    widget.onFinish(context);
  }

  @override
  void didUpdateWidget(FlameSplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasStepsChanged = widget.showBefore != oldWidget.showBefore ||
        widget.showAfter != oldWidget.showAfter ||
        widget.theme.logo != oldWidget.theme.logo;
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
          if (currentStep == null) {
            return Container();
          }
          return _SplashScreenStep(
            builder: steps[currentStep],
            durations: controller._durations,
            key: ObjectKey(currentStep),
          );
        },
      )),
    );
  }

  Widget buildMainLogo(BuildContext context) {
    return Image(
      width: 300,
      image: AssetImage(
        widget.theme.logo,
        package: 'flame_splash_screen',
      ),
    );
  }
}

class _SplashScreenStep extends StatefulWidget {
  const _SplashScreenStep({Key key, this.builder, this.durations})
      : super(key: key);

  final WidgetBuilder builder;
  final _FlameSplashDurations durations;

  @override
  __SplashScreenStepState createState() => __SplashScreenStepState();
}

class __SplashScreenStepState extends State<_SplashScreenStep>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimation;
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
    await Future.delayed(widget.durations.waitDuration);
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
