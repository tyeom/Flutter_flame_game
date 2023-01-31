import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/game/my_game.dart';

abstract class Item extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  int bulletPowerPoint = 10;
  final double _speed = 150;
  final Vector2 _moveDirection = Vector2(0, 1);

  @override
  void onMount() {
    super.onMount();

    // enemy 객체 사이즈의 반지름 0.8배 작은 원형 히트박스 추가
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += _moveDirection * _speed * dt;

    // 스크린 세로 사이즈 범위 밖으로 사라지면 객체 제거
    if (position.y > gameRef.size.y) {
      destroy();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // 플레이어와 충돌시 게임오버
    if (other is Player) {
      destroy();

      // 파워 업 아이템
      if (this is PowerUpgradeItem) {
        gameRef.gameManager.upgradePowrerPoint(
            gameRef.gameManager.bulletPowerPoint + bulletPowerPoint);
      }
    }
  }

  void destroy() {
    // 객체 제거
    removeFromParent();
  }
}

class PowerUpgradeItem extends Item {
  PowerUpgradeItem() {
    size = Vector2(20, 20);
    // 파워 +5
    bulletPowerPoint += 5;
  }

  @override
  Future<void>? onLoad() async {
    // 기본 이미지
    var powerUpgradeItemSprite = await gameRef.loadSprite("Items.png",
        srcPosition: Vector2(68, 2), srcSize: Vector2(16, 12));
    sprite = powerUpgradeItemSprite;
  }
}
