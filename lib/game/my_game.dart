import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_game/components/background.dart';
import 'package:flame_game/main.dart';

class MyGame extends FlameGame {
  final Image backgroundSprite;
  late Background background;

  MyGame(this.backgroundSprite) {}

  void initPositions(Image backgroundSprite) {
    //
  }

  @override
  onLoad() async {
    await super.onLoad();

    Singleton().screenSize = size;
    background = Background(backgroundSprite);

    initPositions(backgroundSprite);

    add(background);
    //this..add(background)
    //..add(background);
  }
}
