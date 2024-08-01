import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class StartScreen extends PositionComponent
    with TapCallbacks, HasGameRef<PixelAdventure> {
  final VoidCallback onStart;
  late SpriteFontRenderer fontRenderer;

  StartScreen({required this.onStart});

  @override
  FutureOr<void> onLoad() {

    // debugMode = true;

    final List<Glyph> glyphs = [
      Glyph('S', left: 64, top: 10, ),
      Glyph('T', left: 72, top: 10),
      Glyph('A', left: 0, top: 0),
      Glyph('R', left: 56, top: 10),
      Glyph(' ', left: 72, top: 50),
      Glyph('G', left: 48, top: 0),
      Glyph('M', left: 16, top: 10),
      Glyph('E', left: 32, top: 0),
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
      ButtonComponent(
        onPressed: onStart,
        button: TextComponent(
          text: 'START GAME',
          textRenderer: fontRenderer,
        ),
        anchor: Anchor.center,
        size: Vector2(480, 60), // x = defaultCharWidth*scale, y = size*scale
        position: Vector2(gameRef.size.x/2, gameRef.size.y/2)
      ),
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {}
}
