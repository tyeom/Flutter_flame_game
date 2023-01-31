import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/components/my_world.dart';
import 'package:flame_game/main.dart';
import 'package:flame_game/managers/enemy_manager.dart';
import 'package:flame_game/managers/game_manager.dart';
import 'package:flame_game/managers/item_manager.dart';

class MyGame extends FlameGame
    with HasTappableComponents, HasDraggableComponents, HasCollisionDetection {
  late MyWorld _world;
  late Player _player;
  final GameManager _gameManager = GameManager();
  late EnemyManager _enemyManager;
  late ItemManager _itemManager;

  MyGame() {}

  GameManager get gameManager => _gameManager;

  @override
  onLoad() async {
    await super.onLoad();

    Singleton().screenSize = size;
    _world = MyWorld();

    add(_world);
    add(_gameManager);

    overlays.add('gameOverlay');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameManager.currentState == GameState.gameOver) {
      return;
    }

    if (_gameManager.currentState == GameState.intro ||
        _gameManager.currentState == GameState.pause) {
      overlays.add('mainMenuOverlay');
      return;
    }
  }

  void _initializeGameStart() {
    // 하단 중앙에 위치
    _player = Player(position: Vector2((size[0] / 2) - 40, size[1] - 70));
    _enemyManager = EnemyManager();
    _itemManager = ItemManager();

    add(_player);
    add(_enemyManager);
    add(_itemManager);
  }

  void startGame() {
    _initializeGameStart();
    _gameManager.changeState(GameState.playing);
    overlays.remove('mainMenuOverlay');
  }

  void pauseAndresumeGame() {
    if (_gameManager.currentState == GameState.playing) {
      pauseEngine();
      overlays.add('mainMenuOverlay');
      _gameManager.changeState(GameState.pause);
    } else if (_gameManager.currentState == GameState.pause) {
      overlays.remove('mainMenuOverlay');
      resumeEngine();
      _gameManager.changeState(GameState.playing);
    }
  }

  void gameOver() {
    _player.destroy();
    _enemyManager.destroy();
    _itemManager.destroy();
    _gameManager.reset();
    _gameManager.changeState(GameState.gameOver);
    overlays.add('gameOverOverlay');
  }

  // 게임오버 이후 다시시작
  void reStartGame() {
    _initializeGameStart();
    _gameManager.changeState(GameState.playing);
    overlays.remove('gameOverOverlay');
  }
}
