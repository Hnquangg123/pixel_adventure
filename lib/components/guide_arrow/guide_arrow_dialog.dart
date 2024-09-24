import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class GuideArrowDialog extends PositionComponent
    with HasGameRef<PixelAdventure> {
  final Paint backgroundPaint;
  final double borderRadius;
  final double padding;
  final Paint borderPaint;
  String text;
  late SpriteFontRenderer fontRenderer;
  late TextComponent textComponent;

  GuideArrowDialog({
    required this.text,
    this.borderRadius = 20.0, // Rounded corners
    this.padding = 20.0, // Padding between text and border
    Color backgroundColor = const Color(0xFF333333), // Background color
    Color borderColor = const Color(0xFFFFFFFF), // Border color
    double borderWidth = 4.0, // Border thickness
  })  : backgroundPaint = Paint()..color = backgroundColor,
        borderPaint = Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke;

  @override
  FutureOr<void> onLoad() {
    final List<Glyph> glyphs = [
      Glyph('A', left: 0, top: 0),
      Glyph('B', left: 8, top: 0),
      Glyph('C', left: 16, top: 0),
      Glyph('D', left: 24, top: 0),
      Glyph('E', left: 32, top: 0),
      Glyph('F', left: 40, top: 0),
      Glyph('G', left: 48, top: 0),
      Glyph('H', left: 56, top: 0),
      Glyph('I', left: 64, top: 0),
      Glyph('J', left: 72, top: 0),
      Glyph('K', left: 0, top: 10),
      Glyph('L', left: 8, top: 10),
      Glyph('M', left: 16, top: 10),
      Glyph('N', left: 24, top: 10),
      Glyph('O', left: 32, top: 10),
      Glyph('P', left: 40, top: 10),
      Glyph('Q', left: 48, top: 10),
      Glyph('R', left: 56, top: 10),
      Glyph('S', left: 64, top: 10),
      Glyph('T', left: 72, top: 10),
      Glyph('U', left: 0, top: 20),
      Glyph('V', left: 8, top: 20),
      Glyph('W', left: 16, top: 20),
      Glyph('X', left: 24, top: 20),
      Glyph('Y', left: 32, top: 20),
      Glyph('Z', left: 40, top: 20),
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
      Glyph('.', left: 0, top: 40),
      Glyph(',', left: 8, top: 40),
      Glyph(':', left: 16, top: 40),
      Glyph('?', left: 24, top: 40),
      Glyph('!', left: 32, top: 40),
      Glyph('(', left: 40, top: 40),
      Glyph(')', left: 48, top: 40),
      Glyph('+', left: 56, top: 40),
      Glyph('-', left: 64, top: 40),
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
      scale: 0.5,
      letterSpacing: 0,
    );

    textComponent = TextComponent(
      text: text,
      textRenderer: fontRenderer,
    );

    // Set position inside dialog box
    textComponent.position = Vector2(padding, padding - 20);

    // Calculate dialog box size based on text size and padding
    final textSize = textComponent.size;
    size = Vector2(textSize.x + 2 * padding, textSize.y + 2 * padding);

    add(textComponent);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Draw background with rounded corners
    final rect = Rect.fromLTWH(0, -20, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, backgroundPaint);

    // Draw border
    canvas.drawRRect(rrect, borderPaint);
    super.render(canvas);
  }
}
