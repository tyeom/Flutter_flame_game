import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

class Player extends PositionComponent {
  late final PlayerComponent _playerComponent;

  Player(Image spriteImag) {
    List<Sprite> spritesGo = [
      Sprite(spriteImag, srcPosition: Vector2(0, 0), srcSize: Vector2(24, 24)),
      Sprite(spriteImag, srcPosition: Vector2(25, 0), srcSize: Vector2(24, 24)),
      Sprite(spriteImag, srcPosition: Vector2(50, 0), srcSize: Vector2(24, 24)),
      Sprite(spriteImag, srcPosition: Vector2(75, 0), srcSize: Vector2(24, 24)),
    ];

    var animatedPlayer = SpriteAnimation.spriteList(spritesGo, stepTime: 0.15);
    _playerComponent = PlayerComponent(animatedPlayer);
    add(_playerComponent);
  }

  void playerUpdate(double dt) {
    _playerComponent.showAnimation = true;
    _playerComponent.update(dt);
  }

  void setPosition(double x, double y) {
    _playerComponent.x = x;
    _playerComponent.y = y;
  }
}

class PlayerComponent extends SpriteAnimationComponent {
  bool showAnimation = true;

  PlayerComponent(SpriteAnimation playerAnimation)
      : super(size: Vector2(40, 40), animation: playerAnimation);

  @override
  void update(double dt) {
    if (showAnimation) {
      super.update(dt);
    }
  }
}
