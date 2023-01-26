import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_game/main.dart';

class Background extends PositionComponent {
  late final BackgroundComponent _background01;
  late final BackgroundComponent _background02;
  late final BackgroundComponent _background03;

  double get background01X => _background01.x;
  double get background01Y => _background01.y;

  double get background02X => _background02.x;
  double get background02Y => _background02.y;

  double get background03X => _background03.x;
  double get background03Y => _background03.y;

  Background(Image spriteImg, Vector2 postion) {
    _background01 = BackgroundComponent(
        spriteImg, Vector2(290, 0), Vector2(144, 280), postion);
    _background02 = BackgroundComponent(
        spriteImg, Vector2(144, 0), Vector2(144, 280), postion);
    _background03 = BackgroundComponent(
        spriteImg, Vector2(0, 0), Vector2(144, 280), postion);

    add(_background01);
    add(_background02);
    add(_background03);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void setPositionBGImg01(double x, double y) {
    _background01.position.x = x;
    _background01.position.y = y;
  }

  void setPositionBGImg02(double x, double y) {
    _background02.position.x = x;
    _background02.position.y = y;
  }

  void setPositionBGImg03(double x, double y) {
    _background03.position.x = x;
    _background03.position.y = y;
  }
}

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent(Image backgroundImag, Vector2 srcPosition,
      Vector2 srcSize, Vector2 postion)
      : super.fromImage(backgroundImag,
            srcPosition: srcPosition,
            srcSize: srcSize,
            position: postion,
            // 배경 이미지 사이즈를 전체 화면 세로 사이즈의 두배로 설정
            size: Vector2(
                Singleton().screenSize!.x, Singleton().screenSize!.y * 2));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
