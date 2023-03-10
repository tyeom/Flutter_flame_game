import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/components/bullet.dart';
import 'package:flame_game/components/enemies_bullet.dart';
import 'package:flame_game/components/enemy.dart';
import 'package:flame_game/game/my_game.dart';

enum PlayerDirection { go, left, right, boom }

class Player extends PositionComponent
    with DragCallbacks, CollisionCallbacks, HasGameRef<MyGame> {
  late final PlayerComponent _playerComponent;
  bool _isDragging = false;

  Player({super.position})
      : super(
          size: Vector2(35, 35),
          anchor: Anchor.center,
        ) {
    var playerImage = Flame.images.fromCache("Player.png");
    var boomImage = Flame.images.fromCache("Boom.png");

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

    List<Sprite> spriteBoom = [
      Sprite(boomImage, srcPosition: Vector2(0, 0), srcSize: Vector2(72, 72)),
      Sprite(boomImage, srcPosition: Vector2(74, 0), srcSize: Vector2(72, 72)),
      Sprite(boomImage, srcPosition: Vector2(146, 0), srcSize: Vector2(72, 72)),
    ];

    var animatedPlayer_go =
        SpriteAnimation.spriteList(spritesGo, stepTime: 0.15);
    var animatedPlayer_left =
        SpriteAnimation.spriteList(spritesLeft, stepTime: 0.15);
    var animatedPlayer_right =
        SpriteAnimation.spriteList(spritesRight, stepTime: 0.15);
    var animatedBoom =
        SpriteAnimation.spriteList(spriteBoom, stepTime: 0.15, loop: false);
    // ??????????????? ?????? Boom ??????????????? ?????? ??? ?????? ??????
    animatedBoom.onComplete = () => destroy();

    _playerComponent = PlayerComponent<PlayerDirection>({
      PlayerDirection.go: animatedPlayer_go,
      PlayerDirection.left: animatedPlayer_left,
      PlayerDirection.right: animatedPlayer_right,
      PlayerDirection.boom: animatedBoom,
    });
    _playerComponent.current = PlayerDirection.go;
    add(_playerComponent);
  }

  double bulletTime = 0;

  @override
  void onMount() {
    super.onMount();

    // player ?????? ???????????? ????????? 0.8??? ?????? ?????? ???????????? ??????
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

    if (_playerComponent.current == PlayerDirection.boom) {
      return;
    }

    bulletTime += dt;
    // 0.3??? ?????? ????????? ??????
    if (bulletTime < 0.3) return;
    bulletTime = 0;

    Bullet bullet = Bullet()
      // Bullet??? ????????? ??????
      ..size = Vector2(19, 25)
      // Bullet??? ?????? ??????
      ..position = position.clone()
      // Bullet??? ????????? ??????
      ..anchor = Anchor.center;
    gameRef.add(bullet);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_playerComponent.current == PlayerDirection.boom) {
      _isDragging = false;
      return;
    }

    _isDragging = true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging) {
      return;
    }

    if (_playerComponent.current == PlayerDirection.boom) {
      _isDragging = false;
      return;
    }

    // ?????? ?????? ?????? ??????
    if (position.y <= 100) {
      position.y += 10;
      return;
    }

    // ?????? ?????? ?????? ??????
    if (position.y >= gameRef.size[1] - 50) {
      position.y -= 10;
      return;
    }

    // ?????? ?????? ?????? ??????
    if (position.x <= 50) {
      position.x += 10;
      return;
    }

    // ?????? ?????? ?????? ??????
    if (position.x >= gameRef.size[0] - 50) {
      position.x -= 10;
      return;
    }

    // ????????? ?????? ?????? ??????
    if (event.delta.x == 0) {
      _playerComponent.current = PlayerDirection.go;
    }
    // ???????????? ??????????????? ??????
    else if (event.delta.x > 0) {
      _playerComponent.current = PlayerDirection.right;
    }
    // ???????????? ??????????????? ??????
    else if (event.delta.x < 0) {
      _playerComponent.current = PlayerDirection.left;
    }
    // ????????? ????????? ?????? ??????
    position.x += event.delta.x;
    position.y += event.delta.y;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (_playerComponent.current == PlayerDirection.boom) {
      _isDragging = false;
      return;
    }

    if (!_isDragging) {
      return;
    }

    _isDragging = false;
    _playerComponent.current = PlayerDirection.go;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Enemy or EnemiesBullet ?????????
    if (other is Enemy || other is EnemiesBullet) {
      _playerComponent.current = PlayerDirection.boom;
    }
  }

  void playerUpdate(PlayerDirection playerDirection) {
    _playerComponent.playerUpdate(playerDirection);
  }

  void setPosition(Vector2 position) {
    _playerComponent.position = position;
  }

  void destroy() {
    removeFromParent();
    gameRef.gameOver();
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
