import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({
    super.position,
    super.size,
  });

  bool reachedCheckPoint = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    reachedCheckPoint = false;
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reachedCheckPoint) _reachCheckPoint();
    super.onCollision(intersectionPoints, other);
  }

  void _reachCheckPoint() {
    reachedCheckPoint = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    // final animationFlagOutTicker = animation!.createTicker();
    // animationFlagOutTicker.completed.whenComplete(() {
    //     animation = SpriteAnimation.fromFrameData(
    //       game.images.fromCache(
    //           'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle) (64x64).png'),
    //       SpriteAnimationData.sequenced(
    //         amount: 10,
    //         stepTime: 0.05,
    //         textureSize: Vector2.all(64),
    //       ),
    //     );
    //     animationFlagOutTicker.reset();
    //   },);

    const flagDuration = Duration(milliseconds: 1300);
    Future.delayed(
      flagDuration,
      () {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache(
              'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
          SpriteAnimationData.sequenced(
            amount: 10,
            stepTime: 0.05,
            textureSize: Vector2.all(64),
          ),
        );
      },
    );
  }
}
