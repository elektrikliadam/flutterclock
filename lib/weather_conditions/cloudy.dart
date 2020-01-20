import 'package:flutter/material.dart';

List<Widget> buildCloudy(AnimationController _mdSpeedAnimationController) {
  return <Widget>[
    Positioned(
      top: 10.0,
      left: 40.0,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: _mdSpeedAnimationController, curve: Curves.easeOutBack),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/Cloud2.png",
          color: Color(0xFFEEEEEE),
          width: 110,
          height: 110,
        ),
      ),
    ),
    Positioned(
      top: 30.0,
      left: 180.0,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: _mdSpeedAnimationController, curve: Curves.easeInOutCirc),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/Cloud1.png",
          color: Color(0xFFEEEEEE),
          width: 90,
          height: 90,
        ),
      ),
    ),
    Positioned(
      top: 10.0,
      left: 320.0,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: _mdSpeedAnimationController, curve: Curves.easeInOutCirc),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/Cloud2.png",
          color: Color(0xFFEEEEEE),
          width: 105,
          height: 105,
        ),
      ),
    ),
    Positioned(
      top: 30.0,
      left: 450.0,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: _mdSpeedAnimationController, curve: Curves.ease),
        alignment: Alignment.center,
        child: Image.asset(
          "assets/Cloud1.png",
          color: Color(0xFFEEEEEE),
          width: 90,
          height: 90,
        ),
      ),
    ),
  ];
}
