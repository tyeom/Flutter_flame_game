import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_game/main.dart';

class Background extends PositionComponent {
  late final BackgroundComponent _background01;
  late final BackgroundComponent _background02;
  late final BackgroundComponent _background03;

  Background(Image spriteImag) {
    _background01 =
        BackgroundComponent(spriteImag, Vector2(290, 0), Vector2(144, 280));
    _background02 =
        BackgroundComponent(spriteImag, Vector2(144, 0), Vector2(144, 280));
    _background03 =
        BackgroundComponent(spriteImag, Vector2(0, 0), Vector2(144, 280));

    add(_background01);
    add(_background02);
    add(_background03);
  }
}

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent(
      Image backgroundImag, Vector2 srcPosition, Vector2 srcSize)
      : super.fromImage(backgroundImag,
            srcPosition: srcPosition,
            srcSize: srcSize,
            size: Singleton().screenSize);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
