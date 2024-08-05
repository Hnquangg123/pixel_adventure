import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LoadScreen extends PositionComponent with HasGameRef<PixelAdventure> {
  late SpriteFontRenderer fontRenderer;

  LoadScreen();

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    final List<Glyph> glyphs = [
      Glyph('L', left: 8, top: 10),
      Glyph('O', left: 32, top: 10),
      Glyph('A', left: 0, top: 0),
      Glyph('D', left: 24, top: 0),
      Glyph('I', left: 64, top: 0),
      Glyph('N', left: 24, top: 10),
      Glyph('G', left: 48, top: 0),
      Glyph('.', left: 0, top: 40),
    ];

    fontRenderer = SpriteFontRenderer.fromFont(
      SpriteFont(
        source: game.images.fromCache('Menu/Text/Text (White) (8x10).png'),
        size: 10,
        ascent: 0,
        glyphs: glyphs,
        defaultCharWidth: 8,
      ),
      scale: 6,
      letterSpacing: 0,
    );

    // add start button
    add(
      TextComponent(
          text: 'LOADING...',
          textRenderer: fontRenderer,
          anchor: Anchor.center,
          size: Vector2(480, 60), // x = defaultCharWidth*scale, y = size*scale
          position: Vector2(gameRef.size.x / 2, gameRef.size.y / 2)),
    );

    return super.onLoad();
  }
}
