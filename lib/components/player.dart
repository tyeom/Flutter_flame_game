import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/components/bullet.dart';
import 'package:flame_game/game/my_game.dart';

enum PlayerDirection { go, left, right }

class Player extends PositionComponent with DragCallbacks, HasGameRef<MyGame> {
  late final PlayerComponent _playerComponent;
  bool _isDragging = false;

  Player({super.position})
      : super(
          size: Vector2(35, 35),
          anchor: Anchor.center,
        ) {
    var playerImage = Flame.images.fromCache("Player.png");

    List<Sprite> spritesGo = [
      Sprite(playerImage, srcPosition: Vector2(0, 0), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(25, 0), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(50, 0), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(75, 0), srcSize: Vector2(24, 24)),
    ];

    List<Sprite> spritesLeft = [
      Sprite(playerImage,
          srcPosition: Vector2(2, 50), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(27, 50), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(52, 50), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(77, 50), srcSize: Vector2(24, 24)),
    ];

    List<Sprite> spritesRight = [
      Sprite(playerImage,
          srcPosition: Vector2(1, 25), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(26, 25), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(51, 25), srcSize: Vector2(24, 24)),
      Sprite(playerImage,
          srcPosition: Vector2(76, 25), srcSize: Vector2(24, 24)),
    ];

    var animatedPlayer_go =
        SpriteAnimation.spriteList(spritesGo, stepTime: 0.15);
    var animatedPlayer_left =
        SpriteAnimation.spriteList(spritesLeft, stepTime: 0.15);
    var animatedPlayer_right =
        SpriteAnimation.spriteList(spritesRight, stepTime: 0.15);

    _playerComponent = PlayerComponent<PlayerDirection>({
      PlayerDirection.go: animatedPlayer_go,
      PlayerDirection.left: animatedPlayer_left,
      PlayerDirection.right: animatedPlayer_right
    });
    _playerComponent.current = PlayerDirection.go;
    add(_playerComponent);
  }

  double bulletTime = 0;

  @override
  void update(double dt) {
    super.update(dt);

    bulletTime += dt;
    if (bulletTime < 0.3) return;
    bulletTime = 0;

    Bullet bullet = Bullet()
      ..size = Vector2(19, 25)
      ..position = position.clone()
      ..anchor = Anchor.center;
    gameRef.add(bullet);
  }

  @override
  void onDragStart(DragStartEvent event) {
    _isDragging = true;
    priority = 100;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging) {
      return;
    }

    // 좌측 범위 초과 금지
    if (position.x <= 150) {
      position.x += 10;
      return;
    }

    // 우측 범위 초과 금지
    if (position.x >= gameRef.size[0] - 150) {
      position.x -= 10;
      return;
    }

    // 드래그 하지 않는 경우
    if (event.delta.x == 0) {
      _playerComponent.current = PlayerDirection.go;
    }
    // 우측으로 드래그중인 경우
    else if (event.delta.x > 0) {
      _playerComponent.current = PlayerDirection.right;
    }
    // 좌측으로 드래그중인 경우
    else if (event.delta.x < 0) {
      _playerComponent.current = PlayerDirection.left;
    }
    // 드래그 방향에 따라 이동
    position.x += event.delta.x;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!_isDragging) {
      return;
    }

    _isDragging = false;
    _playerComponent.current = PlayerDirection.go;
  }

  void playerUpdate(PlayerDirection playerDirection) {
    _playerComponent.playerUpdate(playerDirection);
  }

  void setPosition(Vector2 position) {
    _playerComponent.position = position;
  }
}

class PlayerComponent<T> extends SpriteAnimationGroupComponent<T> {
  PlayerComponent(Map<T, SpriteAnimation> playerAnimationMap)
      : super(size: Vector2(40, 40), animations: playerAnimationMap);

  @override
  void update(double dt) {
    super.update(dt);
  }

  void playerUpdate(PlayerDirection playerDirection) {
    current = playerDirection as T?;
  }
}
