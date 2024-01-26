import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  CustomPageRoute({
    super.settings,
    required this.child,
    this.style = PageTransitionStyle.rightToLeft,
  }) : super(pageBuilder: (_, __, ___) => child);

  final Widget child;
  final PageTransitionStyle style;

  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    Offset? begin;

    switch (style) {
      case (PageTransitionStyle.leftToRight):
        begin = const Offset(-1.0, 0.0);
      case (PageTransitionStyle.rightToLeft):
        begin = const Offset(1.0, 0.0);
      case (PageTransitionStyle.topToBottom):
        begin = const Offset(0.0, -1.0);
      case (PageTransitionStyle.bottomToTop):
        begin = const Offset(0.0, 1.0);
    }

    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}

enum PageTransitionStyle {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}
