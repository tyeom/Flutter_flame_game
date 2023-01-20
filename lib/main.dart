import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 이미지 로드
  var backgroundSprite = await Flame.images.loadAll(["Backgrounds.png"]);

  runApp(MaterialApp(
    title: 'Flame Game',
    home: GestureDetector(
      child: Scaffold(
        body: GameWrapper(MyGame(backgroundSprite[0])),
      ),
    ),
  ));
}

class GameWrapper extends StatelessWidget {
  final MyGame myGame;
  const GameWrapper(this.myGame, {super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: myGame);
  }
}

class Singleton {
  Singleton._privateConstructor();
  static final Singleton _instance = Singleton._privateConstructor();

  late final Vector2? screenSize;

  factory Singleton() {
    return _instance;
  }
}