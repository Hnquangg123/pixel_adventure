import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/guide_arrow/guide_arrow_dialog.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class GuideArrow extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  String text;

  GuideArrow({super.position, super.size, required this.text});

  final stepTime = 0.05;
  final textureSize = Vector2.all(64);

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    add(RectangleHitbox(
      position: Vector2(26, 56),
      size: Vector2(34, 8),
    ));

    priority = 0;

    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Start/Start (Moving) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      showDialog();
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      removeDialog();
    }
    super.onCollisionEnd(other);
  }

  void showDialog() {
    final dialog = GuideArrowDialog(text: text);
    add(dialog);
  }

  void removeDialog() {
    removeWhere(
      (component) => component is GuideArrowDialog,
    );
  }
}
