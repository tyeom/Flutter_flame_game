import 'package:flame/game.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final Game game;

  const ScoreDisplay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // GameManager의 ValueNotifier 값 변경시 처리
    return ValueListenableBuilder(
      valueListenable: (game as MyGame).gameManager.score,
      builder: (context, value, child) {
        return Text('Score: $value',
            style: Theme.of(context).textTheme.displaySmall!);
      },
    );
  }
}
