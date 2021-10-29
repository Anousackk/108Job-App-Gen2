import 'package:flutter/material.dart';

class Fade extends StatefulWidget {
  const Fade(
      {Key? key,
      required this.child,
      required this.visible,
      Duration? duration})
      : duration = duration ?? const Duration(milliseconds: 200),
        super(key: key);

  final Widget child;
  final bool visible;
  final Duration? duration;

  @override
  _FadeState createState() => _FadeState();
}

class _FadeState extends State<Fade> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      value: widget.visible ? 1.0 : 0.0,
      duration: widget.duration,
      vsync: this,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(Fade oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.visible && widget.visible) {
      _animationController.forward();
    } else if (oldWidget.visible && !widget.visible) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
      child: SizeTransition(
        axisAlignment: 1,
        sizeFactor: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
        child: widget.child,
      ),
    );
  }
}

class FadeReverse extends StatefulWidget {
  const FadeReverse(
      {Key? key,
      required this.child,
      required this.visible,
      Duration? duration})
      : duration = duration ?? const Duration(milliseconds: 200),
        super(key: key);

  final Widget child;
  final bool visible;
  final Duration? duration;

  @override
  _FadeReverseState createState() => _FadeReverseState();
}

class _FadeReverseState extends State<FadeReverse>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      value: widget.visible ? 1.0 : 0.0,
      duration: widget.duration,
      vsync: this,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(FadeReverse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.visible && !widget.visible) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
      child: SizeTransition(
        axisAlignment: -1,
        sizeFactor: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
        child: widget.child,
      ),
    );
  }
}
