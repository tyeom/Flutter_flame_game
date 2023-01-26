import 'package:flame/components.dart';
import 'package:flame_game/components/background.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/main.dart';

class MyWorld extends Component with HasGameRef<MyGame> {
  late Background _background;

  @override
  Future<void> onLoad() async {
    var backgroundSprites = gameRef.images.fromCache("Backgrounds.png");
    _background = Background(backgroundSprites, Vector2(0, -gameRef.size.y));
    add(_background);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _background.setPositionBGImg01(
        0, _background.background01Y + (dt * Singleton().ground01Speed));

    if (_background.background01Y >= 0) {
      _background.setPositionBGImg01(0, -gameRef.size.y);
    }

    _background.setPositionBGImg02(
        0, _background.background02Y + (dt * Singleton().ground02Speed));

    if (_background.background02Y >= 0) {
      _background.setPositionBGImg02(0, -gameRef.size.y);
    }

    _background.setPositionBGImg03(
        0, _background.background03Y + (dt * Singleton().ground03Speed));

    if (_background.background03Y >= 0) {
      _background.setPositionBGImg03(0, -gameRef.size.y);
    }
  }
}
