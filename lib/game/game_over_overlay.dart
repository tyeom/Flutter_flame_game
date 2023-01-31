import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class GameOverOverlay extends StatefulWidget {
  final Game game;

  const GameOverOverlay(this.game, {super.key});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  @override
  Widget build(BuildContext context) {
    MyGame game = widget.game as MyGame;

    return LayoutBuilder(builder: (_, constraints) {
      return Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.8,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          'Game Over',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (game.gameManager.currentState ==
                                  GameState.gameOver) {
                                game.reStartGame();
                              }
                            },
                            child: Text(
                              '다시하기',
                              style: const TextStyle(fontSize: 15),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
    });
  }
}
