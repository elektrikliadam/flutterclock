// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:digital_clock/weather_conditions/cloudy.dart';
import 'package:digital_clock/weather_conditions/snowy.dart';
import 'package:digital_clock/weather_conditions/thunderstorm.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'LinearGradientTween.dart';
import './weather_conditions/cloudy.dart';
import './weather_conditions/rainy.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  AnimationController _flareOpacityAnimController;
  AnimationController _innerFlareAnimController;
  AnimationController _flareScaleAnimController;
  AnimationController _starOpacityAnimController;
  AnimationController _starsOpacityAnimController;
  AnimationController _shootingStarAnimController;
  AnimationController _cloudyAnimController;
  AnimationController _mdSpeedAnimationController;
  AnimationController _foggyAnimController;

  bool _isSunDown = false;
  double angle = 0.0;
  bool _isSimulating = false;
  Animation<Color> flareAnim;
  Animation _opacityAnimation;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    _foggyAnimController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat(reverse: true);
    _flareOpacityAnimController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 2000,
        ))
      ..forward();
    CurvedAnimation _curve = CurvedAnimation(
        parent: _flareOpacityAnimController, curve: Curves.easeOutBack);

    _opacityAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_curve);

    _opacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flareOpacityAnimController.reset();
        _flareOpacityAnimController.forward();
      } else if (status == AnimationStatus.dismissed) {
        _flareOpacityAnimController.forward();
      }
    });

    _innerFlareAnimController = AnimationController(
      lowerBound: .5, // .5
      upperBound: .8, // .7

      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    )..repeat(reverse: true);
    _flareScaleAnimController = AnimationController(
      lowerBound: .1, //.3
      upperBound: .45,
      // lowerBound: .75,
      // upperBound: .85,
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    )..repeat(reverse: false);

    flareAnim = ColorTween(
            begin: Colors.red,
            // begin: Colors.yellow[50].withOpacity(.2),
            end: Colors.transparent)
        .animate(_flareOpacityAnimController);

    _starOpacityAnimController = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 3,
        ))
      ..repeat(reverse: true);

    _starsOpacityAnimController = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 3,
        ));
    _mdSpeedAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      lowerBound: .8,
      upperBound: 1,
      vsync: this,
    );

    _mdSpeedAnimationController.repeat(reverse: true).orCancel;

    _shootingStarAnimController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ))
      ..repeat().orCancel;

    _cloudyAnimController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      _timer = Timer(
        Duration(milliseconds: _isSimulating ? 1 : 1000),
        _updateTime,
      );
    });

    if (angle > 180) {
      angle = 0;
      if (_isSunDown) {
        _isSunDown = false;
      } else {
        _isSunDown = true;
      }
    }

    angle += .3;
  }

  Widget _buildCircle(String assetName, double radius) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      child: Container(
        child: Image.asset(assetName),
      ),
    );
  }

  Widget _buildSunMoon(double radius) {
    return Align(
      alignment: Alignment.topCenter,
      child: Transform.rotate(
        origin: Offset(0, MediaQuery.of(context).size.height - radius * 2),
        // angle: 0,
        angle: (math.pi / 180) * (angle - 90),
        child: Transform.rotate(
          alignment: Alignment.center,
          angle: -(math.pi / 180) * (angle - 90),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            ScaleTransition(
              scale: CurvedAnimation(
                  parent: _innerFlareAnimController, curve: Curves.easeOutBack),
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.yellow[100].withOpacity(.2),
                radius: 40,
              ),
            ),
            // CircleAvatar(
            //   backgroundColor: Colors.transparent,
            //   radius: 40,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       gradient: RadialGradient(
            //         colors: [
            //           Colors.transparent,
            //           Colors.yellow[200].withOpacity(.5)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            ScaleTransition(
              scale: CurvedAnimation(
                  parent: _innerFlareAnimController, curve: Curves.easeOutBack),
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.yellow[50].withOpacity(.2),
                radius: 33,
              ),
            ),
            // ScaleTransition(
            //   scale: CurvedAnimation(
            //       parent: _flareScaleAnimController, curve: Curves.easeOutBack),
            //   alignment: Alignment.center,
            //   child: FadeTransition(
            //     opacity: _opacityAnimation,
            //     child: CircleAvatar(
            //       // backgroundColor: Colors.red,
            //       backgroundColor: Colors.yellow[100].withOpacity(.3),
            //       radius: 40,
            //     ),
            //   ),
            // ),

            _buildCircle(
                _isSunDown ? "assets/Moon.png" : "assets/Sun.png", radius),
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildWeather() {
    if (widget.model.weatherCondition == WeatherCondition.cloudy)
      return buildCloudy(_mdSpeedAnimationController);
    else if (widget.model.weatherCondition == WeatherCondition.rainy)
      return [RainyWeather()];
    else if (widget.model.weatherCondition == WeatherCondition.snowy)
      return [SnowyWeather()];
    else if (widget.model.weatherCondition == WeatherCondition.thunderstorm)
      return [ThunderstormyWeather()];
    return [];
  }

  Widget _buildHill() {
    return Container(
      child: Image.asset(
        "assets/Hill.png",
        color: Colors.greenAccent,
      ),
    );
  }

  Widget _buildClockText() {
    final fontSize = MediaQuery.of(context).size.width / 6.5;

    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);

    final minute = DateFormat('mm').format(_dateTime);
    final defaultStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'MckloudShadow',
      fontSize: fontSize,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "$hour:$minute",
          style: defaultStyle,
        ),
        Text(
          widget.model.temperatureString,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "MckloudBlack",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _foggyOpacityAnim = ColorTween(begin: Colors.white, end: Colors.black);

    LinearGradient _backgroundGradient = LinearGradientTween(
      begin: LinearGradient(
          tileMode: TileMode.mirror,
          colors: [
            Color(0xFF08061E),
            Color(0xFF2F2D52),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
      end: LinearGradient(
          tileMode: TileMode.mirror,
          colors: _isSunDown
              ? [
                  Color(0xFF08061E),
                  Color(0xFF6B68B9),
                ]
              : [
                  Color(0xFF25C9FD),
                  Color(0xFF8AEFFE),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
    ).lerp(angle <= 90 ? angle / 90 : 1 - ((angle - 90) / 90));
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: _buildSunMoon(30.0)),
          ..._buildWeather(),
          Positioned(top: 120, left: 150, child: _buildClockText()),
          Positioned(bottom: -110, child: _buildHill()),
          Positioned(
            top: 0,
            right: 0,
            child: RaisedButton(
                child: Text("Simulate"),
                onPressed: () {
                  if (_isSimulating)
                    _isSimulating = false;
                  else
                    _isSimulating = true;
                }),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: widget.model.weatherCondition == WeatherCondition.foggy
            ? LinearGradient(colors: [
                Colors.grey,
                _isSunDown ? Colors.blueGrey : Colors.yellow[50]
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            : _backgroundGradient,
      ),
    );

    // final _buildOthers = Container(
    //   child: Stack(children: <Widget>[
    //     Positioned.fill(
    //       child: _isSunDown
    //           ? AnimatedOpacity(
    //               duration: Duration(seconds: 10),
    //               opacity: Tween(
    //                 begin: 0.0,
    //                 end: 1.0,
    //               ).animate(_starsOpacityAnimController).value,
    //               child: Container(color: Colors.red),
    //             )
    //           // ? FadeTransition(
    //           //     opacity: Tween(
    //           //       begin: 0.0,
    //           //       end: 1.0,
    //           //     ).animate(_starsOpacityAnimController),
    //           //     child: Container(
    //           //       color: Colors.red,
    //           //     )
    //           //     //   child: buildStars(
    //           //     //       _starOpacityAnimController, _shootingStarAnimController),
    //           //     )
    //           : Container(),
    //     ),
    //     ..._buildWeather(),
    //   ]),
    // );
    // return RainWeather();

    // return Container(
    //   child: _buildOthers,
    //   decoration: BoxDecoration(
    //     gradient: _backgroundGradient,
    //   ),
    // );
  }
}
