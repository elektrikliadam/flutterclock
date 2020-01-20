// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:digital_clock/weather_conditions/cloudy.dart';
import 'package:digital_clock/weather_conditions/snowy.dart';
import 'package:digital_clock/weather_conditions/thunderstorm.dart';
import 'package:digital_clock/weather_conditions/windy.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import './custom_widgets/LinearGradientTween.dart';
import './weather_conditions/cloudy.dart';
import './weather_conditions/rainy.dart';

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
  AnimationController _innerFlareAnimController;
  AnimationController _mdSpeedAnimationController;

  bool _isSunDown = false;
  double angle = 0.0;
  bool _isSimulating = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();

    _innerFlareAnimController = AnimationController(
      lowerBound: .5,
      upperBound: .8,
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    )..repeat(reverse: true);

    _mdSpeedAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      lowerBound: .8,
      upperBound: 1,
      vsync: this,
    )..repeat(reverse: true).orCancel;

    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.dispose();
    super.dispose();
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
            ScaleTransition(
              scale: CurvedAnimation(
                  parent: _innerFlareAnimController, curve: Curves.easeOutBack),
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.yellow[50].withOpacity(.2),
                radius: 33,
              ),
            ),
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
      return [ThunderStormyWeather()];
    else if (widget.model.weatherCondition == WeatherCondition.windy)
      return [WindyWeather()];
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

  Widget _buildClockText(double fontSize) {
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
    final fontSize = MediaQuery.of(context).size.width / 6.5;

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
          Positioned(
              top: 120,
              left: MediaQuery.of(context).size.height / 2 - fontSize / 2,
              child: _buildClockText(fontSize)),
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
  }
}
