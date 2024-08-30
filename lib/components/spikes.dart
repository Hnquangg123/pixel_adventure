import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Spikes extends SpriteComponent with HasGameRef<PixelAdventure> {

  bool isFlip;

  Spikes({super.position, super.size, required this.isFlip});

  @override
  FutureOr<void> onLoad() {

    // debugMode = true;

    sprite = Sprite(
      game.images.fromCache('Traps/Spikes/Idle.png'),
    );

    add(
      RectangleHitbox(
        position: Vector2(0, 8),
        size: Vector2(16, 8),
        collisionType: CollisionType.passive,
      ),
    );

    if (isFlip) {
      flipVerticallyAroundCenter();
    }

    return super.onLoad();
  }
}
