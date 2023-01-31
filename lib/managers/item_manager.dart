import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_game/components/enemy.dart';
import 'package:flame_game/components/item.dart';
import 'package:flame_game/game/my_game.dart';

final Random _rand = Random();

class ItemManager extends Component with HasGameRef<MyGame> {
  late Timer _itemTimer;
  final Random _random = Random();
  // 아이템 표시 횟수
  final Map<String, int> _itemDisplayCount = {
    'powerup': 0,
  };

  ItemManager() : super() {
    _itemTimer = Timer(10, onTick: _enemyTick, repeat: true);
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

    // 0 ~ 1 사이 난수 생성 * 스크린 너비
    // 스크린 너비 사이즈 만큼 랜덤 X 위치
    Vector2 position = Vector2(_random.nextDouble() * gameRef.size.x, 0);

    // powerup 아이템 최대 3개 까지 표시
    int powerUpItemCurrentCnt = _itemDisplayCount['powerup']!;
    if (powerUpItemCurrentCnt <= 3) {
      Item powerUpgradeItem = PowerUpgradeItem();

      // 컴포넌트가 화면안에 유지 되도록 고정
      position.clamp(
        Vector2.zero() + powerUpgradeItem.size / 2,
        gameRef.size - powerUpgradeItem.size / 2,
      );

      powerUpgradeItem.anchor = Anchor.center;
      powerUpgradeItem.position = position;
      gameRef.add(powerUpgradeItem);

      powerUpItemCurrentCnt++;
      _itemDisplayCount["powerup"] = powerUpItemCurrentCnt;
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
