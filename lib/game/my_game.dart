import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_game/components/background.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/main.dart';

class MyGame extends FlameGame {
  final Image backgroundSprite;
  final Image playerSprite;

  late Background background;
  late Player player;

  MyGame(this.backgroundSprite, this.playerSprite) {}

  void initPositions() {
    player.setPosition((size[0] / 2) - 40, size[1] - 70);
  }

  @override
  onLoad() async {
    await super.onLoad();

    Singleton().screenSize = size;
    background = Background(backgroundSprite);
    player = Player(playerSprite);

    initPositions();

    this
      ..add(background)
      ..add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.playerUpdate(dt);
  }
}
