import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game/game/game_over_overlay.dart';
import 'package:flame_game/game/game_overlay.dart';
import 'package:flame_game/game/main_menu_overlay.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();

  // 이미지 로드
  await Flame.images.loadAll([
    "Backgrounds.png",
    "Background_Grid.png",
    "Player.png",
    "Bullets.png",
    "Boom.png",
    "Items.png",
  ]);

  // runApp(MaterialApp(
  //   title: 'Flame Game',
  //   home: GestureDetector(
  //     child: Scaffold(
  //       body: GameWrapper(MyGame()),
  //     ),
  //   ),
  // ));

  runApp(MaterialApp(
    title: 'Flame Game',
    debugShowCheckedModeBanner: false,
    home: GameWrapper(MyGame()),
  ));
}

class GameWrapper extends StatelessWidget {
  final MyGame myGame;
  const GameWrapper(this.myGame, {super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: myGame,
      // overlay 위젯 등록
      overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
        'gameOverlay': (context, game) => GameOverlay(game),
        'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
        'gameOverOverlay': (context, game) => GameOverOverlay(game),
      },
    );
  }
}

class Singleton {
  Singleton._privateConstructor();
  static final Singleton _instance = Singleton._privateConstructor();

  late final Vector2? screenSize;
  double get ground01Speed => 120;
  double get ground02Speed => 220;
  double get ground03Speed => 320;

  factory Singleton() {
    return _instance;
  }
}
