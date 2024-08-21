import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pixel_adventure/blocs/score/score_bloc.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class ScoreBar extends PositionComponent
    with
        HasGameRef<PixelAdventure>,
        FlameBlocListenable<ScoreBloc, ScoreState> {
  late SpriteFontRenderer fontRenderer;

  late int gamePoint;
  late TextComponent scoreComponent;

  ScoreBar({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    gamePoint = game.scoreBloc.state.score;

    final List<Glyph> glyphs = [
      Glyph('S', left: 64, top: 10),
      Glyph('C', left: 16, top: 0),
      Glyph('O', left: 32, top: 10),
      Glyph('R', left: 56, top: 10),
      Glyph('E', left: 32, top: 0),
      Glyph(':', left: 16, top: 40),
      Glyph('0', left: 0, top: 30),
      Glyph('1', left: 8, top: 30),
      Glyph('2', left: 16, top: 30),
      Glyph('3', left: 24, top: 30),
      Glyph('4', left: 32, top: 30),
      Glyph('5', left: 40, top: 30),
      Glyph('6', left: 48, top: 30),
      Glyph('7', left: 56, top: 30),
      Glyph('8', left: 64, top: 30),
      Glyph('9', left: 72, top: 30),
      Glyph(' ', left: 72, top: 40),
    ];

    fontRenderer = SpriteFontRenderer.fromFont(
      SpriteFont(
        source: game.images.fromCache('Menu/Text/Text (White) (8x10).png'),
        size: 10,
        ascent: 0,
        glyphs: glyphs,
        defaultCharWidth: 8,
      ),
      scale: 2,
      letterSpacing: 0,
    );

    scoreComponent = TextComponent(
      text: 'SCORE: $gamePoint',
      textRenderer: fontRenderer,
    );

    // add start button
    add(scoreComponent);

    return super.onLoad();
  }

  @override
  bool listenWhen(ScoreState previousState, ScoreState newState) {
    return newState.score > previousState.score;
  }

  @override
  void onNewState(ScoreState state) {
    gamePoint = state.score;
    game.gamePoint = state.score;
    if (state.score >= 25 * state.liveIncreaseCount) {
      game.increaseLife(true);
    }
    remove(scoreComponent);
    scoreComponent = TextComponent(
      text: 'SCORE: $gamePoint',
      textRenderer: fontRenderer,
    );
    add(scoreComponent);
    super.onNewState(state);
  }
}
