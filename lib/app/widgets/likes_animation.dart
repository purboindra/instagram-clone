import 'package:flutter/material.dart';

class LikesAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimation;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikesAnimation({
    Key? key,
    required this.child,
    required this.isAnimation,
    this.duration = const Duration(microseconds: 150),
    this.onEnd,
    this.smallLike = false,
  }) : super(key: key);

  @override
  State<LikesAnimation> createState() => _LikesAnimationState();
}

class _LikesAnimationState extends State<LikesAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        microseconds: widget.duration.inMilliseconds ~/ 2,
      ),
    );
    scale = Tween<double>(begin: 1, end: 2).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant LikesAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimation != oldWidget.isAnimation) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimation || widget.smallLike) {
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(const Duration(microseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
