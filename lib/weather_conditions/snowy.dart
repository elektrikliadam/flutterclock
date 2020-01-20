import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:async';

ImageMap _images;

class SnowyWeather extends StatefulWidget {
  SnowyWeather({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RainyWeatherState();
  }
}

class _RainyWeatherState extends State<SnowyWeather> {
  bool assetsLoaded = false;
  NodeWithSize rootNode;

  Future<Null> _loadAssets(AssetBundle bundle) async {
    _images = new ImageMap(bundle);
    await _images.load(<String>[
      'assets/Snow1.png',
      'assets/Snow2.png',
      'assets/Snow3.png',
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
    _rain = Snow();
    _rain.position = Offset(0, 0);
    addChild(_rain);
    _rain.active = true;
  }
  Snow _rain;
}

class Snow extends Node {
  Sprite _snowSprite3 = Sprite.fromImage(_images['assets/Snow3.png']);

  Snow() {
    _addParticles(_snowSprite3.texture, 1.0);
    _addParticles(_snowSprite3.texture, 1.5);
    _addParticles(_snowSprite3.texture, 2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = new ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1600.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 150.0 / distance,
        speedVar: 50.0 / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 20.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 2.0,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance);
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(new MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(new MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}
