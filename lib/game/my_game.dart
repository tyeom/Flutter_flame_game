import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/components/my_world.dart';
import 'package:flame_game/main.dart';

class MyGame extends FlameGame
    with HasTappableComponents, HasDraggableComponents {
  late MyWorld world;
  late Player player;

  MyGame() {}

  void initPositions() {
    //player.setPosition(Vector2((size[0] / 2) - 40, size[1] - 70));
  }

  @override
  onLoad() async {
    await super.onLoad();

    Singleton().screenSize = size;
    world = MyWorld();
    // 하단 중앙에 위치
    player = Player(position: Vector2((size[0] / 2) - 40, size[1] - 70));

    initPositions();

    add(world);
    add(player);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
