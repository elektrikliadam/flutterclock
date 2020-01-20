import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:async';
import 'dart:ui' as ui show Image;

ImageMap _images;

class WindyWeather extends StatefulWidget {
  WindyWeather({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _WindyWeatherState();
  }
}

class _WindyWeatherState extends State<WindyWeather> {
  bool assetsLoaded = false;
  NodeWithSize rootNode;

  Future<Null> _loadAssets(AssetBundle bundle) async {
    _images = new ImageMap(bundle);
    await _images.load(<String>[
      'assets/Cloud1.png',
      'assets/Cloud2.png',
    ]);
  }

  @override
  void initState() {
    super.initState();
    AssetBundle bundle = rootBundle;
    _loadAssets(bundle).then((_) {
      setState(() {
        assetsLoaded = true;
        rootNode = WeatherWorld();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!assetsLoaded)
      return Container(
        child: Text("Loading"),
      );
    return SpriteWidget(rootNode, SpriteBoxTransformMode.scaleToFit);
  }
}

class WeatherWorld extends NodeWithSize {
  WeatherWorld() : super(const Size(2048.0, 2048.0)) {
    _clouds1 = new Wind(
      image: _images['assets/Cloud1.png'],
      loopTime: 2.0,
      startFrom: 256.0,
    );
    _clouds2 = new Wind(
        image: _images['assets/Cloud2.png'], loopTime: 3, startFrom: 400.0);
    _clouds3 = new Wind(
        image: _images['assets/Cloud1.png'], loopTime: 3.5, startFrom: 512.0);

    addChild(_clouds1);
    addChild(_clouds2);
    addChild(_clouds3);
  }
  Wind _clouds1;
  Wind _clouds2;
  Wind _clouds3;
}

class Wind extends Node {
  Wind({ui.Image image, double loopTime, double startFrom}) {
    // Creates and positions the two cloud sprites.
    _sprites.add(_createSprite(image));
    _sprites[0].position = Offset(1024.0, startFrom);
    addChild(_sprites[0]);

    _sprites.add(_createSprite(image));
    _sprites[1].position = Offset(3072.0, startFrom);
    addChild(_sprites[1]);

    // Animates the clouds across the screen.
    motions.run(new MotionRepeatForever(new MotionTween<Offset>(
        (a) => position = a, Offset.zero, Offset(-2048.0, 0.0), loopTime)));
  }

  List<Sprite> _sprites = <Sprite>[];

  Sprite _createSprite(ui.Image image) {
    Sprite sprite = new Sprite.fromImage(image);
    return sprite;
  }

  set active(bool active) {
    // Toggle visibility of the cloud layer
    double opacity;
    if (active)
      opacity = 1.0;
    else
      opacity = 0.0;

    for (Sprite sprite in _sprites) {
      sprite.motions.stopAll();
      sprite.motions.run(new MotionTween<double>(
          (a) => sprite.opacity = a, sprite.opacity, opacity, 1.0));
    }
  }
}
