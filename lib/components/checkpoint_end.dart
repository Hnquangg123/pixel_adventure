import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pixel_adventure/blocs/level/level_bloc.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class CheckpointEnd extends SpriteAnimationComponent
    with
        HasGameRef<PixelAdventure>,
        CollisionCallbacks,
        FlameBlocListenable<LevelBloc, LevelState>,
        HasVisibility {
  CheckpointEnd({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/End/End (Idle).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    
    game.bossStart();
    isVisible = false;

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachCheckPoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachCheckPoint() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/End/End (Pressed) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 8,
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

    await animationTicker?.completed;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/End/End (Idle).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
  }

  @override
  void onNewState(LevelState state) {
    if (state.isBossOver(state.status)) {
      add(RectangleHitbox(
        position: Vector2(18, 56),
        size: Vector2(12, 8),
        collisionType: CollisionType.passive,
      ));
      isVisible = true;
    }
    super.onNewState(state);
  }
}
