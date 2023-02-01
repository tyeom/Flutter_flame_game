import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_game/components/item.dart';
import 'package:flame_game/game/my_game.dart';

final Random _rand = Random();

class ItemManager extends Component with HasGameRef<MyGame> {
  late Timer _itemTimer;
  final Random _random = Random();

  ItemManager() : super() {
    _itemTimer = Timer(15, onTick: _enemyTick, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    _itemTimer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _itemTimer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _itemTimer.update(dt);
  }

  void _enemyTick() {
    if (gameRef.buildContext == null) return;

    // powerup 아이템은 최대 power 20이 되면 표시 안되도록
    if (gameRef.gameManager.bulletPowerPoint < 20) {
      // 0 ~ 1 사이 난수 생성 * 스크린 너비
      // 스크린 너비 사이즈 만큼 랜덤 X 위치
      Vector2 position = Vector2(_random.nextDouble() * gameRef.size.x, 0);

      Item powerUpgradeItem = PowerUpgradeItem();

      // 컴포넌트가 화면안에 유지 되도록 고정
      position.clamp(
        Vector2.zero() + powerUpgradeItem.size / 2,
        gameRef.size - powerUpgradeItem.size / 2,
      );

      powerUpgradeItem.anchor = Anchor.center;
      powerUpgradeItem.position = position;
      gameRef.add(powerUpgradeItem);
    }
  }

  void reset() {
    _itemTimer.start();
  }

  void destroy() {
    _itemTimer.stop();
    removeFromParent();
  }
}
