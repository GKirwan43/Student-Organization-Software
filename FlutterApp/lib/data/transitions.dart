import 'package:flutter/material.dart';

// Transition up
Route up(screen) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            ));
      },
      transitionDuration: const Duration(milliseconds: 250));
}

// Transition right to left
Route rightToLeft(screen) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            ));
      },
      transitionDuration: const Duration(milliseconds: 250));
}

// Transition fade
Route fade(screen) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 100));
}
