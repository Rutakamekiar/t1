import 'package:flutter/material.dart';

class RouteTransitionStyles {
  static Widget defaultStyle(context, animation, secondaryAnimation, child) {
    var tween = Tween(begin: 0.0, end: 1.0);
    var curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.ease,
    );
    return FadeTransition(
      opacity: tween.animate(curvedAnimation),
      child: child,
    );
  }
}