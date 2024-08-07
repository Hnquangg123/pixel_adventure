import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelButton extends TextComponent
    with HasGameRef<PixelAdventure> {
  late SpriteFontRenderer fontRenderer;


  LevelButton({
    super.position,
    super.size,
    super.text,
    super.textRenderer,
  });

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    final List<Glyph> glyphs = [
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
      Glyph('?', left: 24, top: 40),
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

    textRenderer = fontRenderer;

    return super.onLoad();
  }

}
