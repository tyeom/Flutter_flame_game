import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/game/my_game.dart';

class Bullet extends PositionComponent with HasGameRef<MyGame> {
  final double _speed = 800;

  Bullet() {
    var bulletsSprites = Flame.images.fromCache("Bullets.png");
    var bullet01 = SpriteComponent.fromImage(bulletsSprites,
        srcPosition: Vector2(3, 0), srcSize: Vector2(4, 7));
    var bullet02 = SpriteComponent.fromImage(bulletsSprites,
        srcPosition: Vector2(12, 0), srcSize: Vector2(11, 11));
    var bullet03 = SpriteComponent.fromImage(bulletsSprites,
        srcPosition: Vector2(3, 0), srcSize: Vector2(4, 7));

    bullet01.position = Vector2(0, 0);
    bullet02.position = Vector2(6, 0);
    bullet03.position = Vector2(17, 0);

    add(bullet01);
    add(bullet02);
    add(bullet03);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y -= dt * _speed;

    // 스크린 범위 밖으로 나가면 객체 제거
    if (position.y < 0) {
      removeFromParent();
    }
  }
}
