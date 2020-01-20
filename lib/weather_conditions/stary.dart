import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
          // shape: BoxShape.circle,
          gradient: RadialGradient(
              colors: [Colors.white, Colors.white70],
              radius: .3,
              stops: [.1, 1]),
          borderRadius: BorderRadius.circular(50)),
    );
  }
}

Widget buildStars(AnimationController _controller,
    AnimationController _shootingStarController) {
  // CurvedAnimation _curve =
  // CurvedAnimation(parent: _opacityAnimController, curve: Curves.easeInOut);

  var _opacityAnimation = Tween(
    begin: 0.5,
    end: 1.0,
  ).animate(_controller);

  // _controller.addStatusListener((status) {
  //   if (status == AnimationStatus.completed)
  //     _controller.reverse();
  //   else if (status == AnimationStatus.dismissed) {
  //     _controller.forward();
  //   }
  // });

  return Container(
    child: Stack(
      children: <Widget>[
        Positioned(
          top: 30,
          left: 50,
          child: FadeTransition(
              opacity: Tween(
                begin: 0.5,
                end: 1.0,
              ).animate(_controller),
              child: new Star()),
        ),
        Positioned(
            top: 100,
            left: 100,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.8,
                end: 1.0,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 80,
            left: 200,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.3,
                end: 1.0,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 50,
            left: 280,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.6,
                end: 1.0,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 80,
            left: 350,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.7,
                end: 1.0,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 30,
            left: 400,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.5,
                end: 0.7,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 100,
            left: 450,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.5,
                end: 0.7,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 50,
            left: 500,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.5,
                end: 1.0,
              ).animate(_controller),
              child: new Star(),
            )),
        Positioned(
            top: 120,
            left: 570,
            child: FadeTransition(
              opacity: Tween(
                begin: 0.3,
                end: .7,
              ).animate(_controller),
              child: new Star(),
            )),
        // Positioned(
        //   top: 300,
        //   left: 100,
        //   child: new Container(
        //     transform: new Matrix4.rotationZ(-0.5),
        //     width: Tween<double>(begin: 450, end: 0.0).evaluate(
        //       CurvedAnimation(
        //           parent: _shootingStarController, curve: new Interval(0.4, 0.6)),
        //     ),
        //     height: 2.0,
        //     decoration: new BoxDecoration(
        //         // color: const Color(0xFF2A2228),
        //         ),
        //     child: new Container(
        //       margin: new EdgeInsets.only(),
        //       decoration: new BoxDecoration(
        //         gradient: new LinearGradient(
        //           colors: [
        //             Colors.transparent,
        //             // const Color(0xFF2A2228),
        //             const Color(0xFFFFFFFF),
        //           ],
        //           stops: ([0.9, 0.8]),
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    ),
  );
}

// class Stars extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _StarsState();
//   }

// }

// class _StarsState extends State<Stars> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Positioned.fill(ch),);
//   }

// }
