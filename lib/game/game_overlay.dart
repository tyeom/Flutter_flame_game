import 'package:flame/game.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/game/score_display.dart';
import 'package:flutter/material.dart';

class GameOverlay extends StatefulWidget {
  final Game game;

  const GameOverlay(this.game, {super.key});

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScoreDisplay(game: widget.game),
              ElevatedButton(
                onPressed: () => (widget.game as MyGame).pauseAndresumeGame(),
                child: const Icon(
                  Icons.pause,
                  size: 30,
                ),
              ),
            ],
          ),
        ));
  }
}
