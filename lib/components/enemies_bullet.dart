import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/game/my_game.dart';

abstract class EnemiesBullet extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final double _speed = 300;

  @override
  void onMount() {
    super.onMount();

    // player 객체 사이즈의 반지름 0.8배 작은 원형 히트박스 추가
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Player 충돌시
    if (other is Player) {
      destroy();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * _speed;

    // 스크린 세로 사이즈 범위 밖으로 사라지면 객체 제거
    if (position.y > gameRef.size.y) {
      destroy();
    }
  }

  void destroy() {
    removeFromParent();
  }
}

class EnemyBullet01 extends EnemiesBullet {
  EnemyBullet01() {
    size = Vector2(5, 13);
  }

  @override
  Future<void>? onLoad() async {
    var bullerImage = await gameRef.images.load("Bullets.png");
    var bullet = SpriteComponent.fromImage(bullerImage,
        srcPosition: Vector2(58, 0), srcSize: Vector2(4, 12));

    add(bullet);
  }
}

class EnemyBullet02 extends EnemiesBullet {
  EnemyBullet02() {
    size = Vector2(7, 10);
  }

  @override
  Future<void>? onLoad() async {
    var bullerImage = await gameRef.images.load("Bullets.png");
    var bullet = SpriteComponent.fromImage(bullerImage,
        srcPosition: Vector2(35, 0), srcSize: Vector2(6, 9));

    add(bullet);
  }
}

class EnemyBullet03 extends EnemiesBullet {
  EnemyBullet03() {
    size = Vector2(11, 11);
  }

  @override
  Future<void>? onLoad() async {
    var bullerImage = await gameRef.images.load("Bullets.png");
    var bullet = SpriteComponent.fromImage(bullerImage,
        srcPosition: Vector2(66, 0), srcSize: Vector2(10, 10));

    add(bullet);
  }
}
