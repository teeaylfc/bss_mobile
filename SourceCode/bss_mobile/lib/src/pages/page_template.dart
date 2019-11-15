import 'package:flutter/material.dart';

class AppPage {
  final AnimationController controller;
  final Widget body;
  CurvedAnimation _animation;

  FadeTransition buildTransition(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: body,
    );
  }

  AppPage({this.body, TickerProvider vsync}) : this.controller = new AnimationController(vsync: vsync, duration: Duration(milliseconds: 500)) {
    _animation = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
  }
}
