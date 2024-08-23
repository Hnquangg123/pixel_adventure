import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class FallingPlatform extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  FallingPlatform({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Falling Platforms/On (32x10).png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.05,
        textureSize: Vector2(32, 10),
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      collidingWithPlayer();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void collidingWithPlayer() {
    print('colliding platform');
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Falling Platforms/Off.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2(32, 10),
      ),
    );
  }
}
