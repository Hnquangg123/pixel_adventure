import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LifeBar extends SpriteComponent with HasGameRef<PixelAdventure> {
  LifeBar({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Items/Heart/heart.png'));

    return super.onLoad();
  }
}
