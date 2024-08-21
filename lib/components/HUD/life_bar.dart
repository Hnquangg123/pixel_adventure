import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pixel_adventure/blocs/score/score_bloc.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LifeBar extends SpriteComponent
    with
        HasGameRef<PixelAdventure>,
        FlameBlocListenable<ScoreBloc, ScoreState> {
  late SpriteFontRenderer fontRenderer;
  late TextComponent lifeComponent;

  late int live;

  LifeBar({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Items/Heart/heart.png'));

    live = game.scoreBloc.state.live;

    final List<Glyph> glyphs = [
      Glyph('X', left: 24, top: 20),
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
      scale: 1.5,
      letterSpacing: 0,
    );

    position = Vector2(300, 8);

    lifeComponent = TextComponent(
      text: ' X $live',
      textRenderer: fontRenderer,
      position: Vector2(size.x, size.y / 5),
    );

    add(lifeComponent);

    return super.onLoad();
  }

  @override
  bool listenWhen(ScoreState previousState, ScoreState newState) {
    
    bool condition = previousState.live != newState.live ;

    return condition;
  }

  @override
  void onNewState(ScoreState state) {
    live = state.live;
    remove(lifeComponent);
    lifeComponent = TextComponent(
      text: ' X $live',
      textRenderer: fontRenderer,
      position: Vector2(size.x, size.y / 5),
    );
    add(lifeComponent);
    super.onNewState(state);
  }
}
