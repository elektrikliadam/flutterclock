import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'dart:async';

ImageMap _images;

class RainyWeather extends StatefulWidget {
  RainyWeather({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RainyWeatherState();
  }
}

class _RainyWeatherState extends State<RainyWeather> {
  bool assetsLoaded = false;
  NodeWithSize rootNode;

  Future<Null> _loadAssets(AssetBundle bundle) async {
    _images = new ImageMap(bundle);
    await _images.load(<String>[
      'assets/Raindrop.png',
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
    _rain = Rain();
    _rain.position = Offset(0, 0);
    addChild(_rain);
    _rain.active = true;
  }
  Rain _rain;
}

class Rain extends Node {
  Sprite _rainSprite = Sprite.fromImage(_images['assets/Raindrop.png']);
  Rain() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = new ParticleSystem(_rainSprite.texture,
        transferMode: BlendMode.srcOver,
        posVar: const Offset(1600.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 1000.0 / distance,
        speedVar: 100.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.2 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 1.5 * distance,
        lifeVar: 1.0 * distance);
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 0.0;
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
