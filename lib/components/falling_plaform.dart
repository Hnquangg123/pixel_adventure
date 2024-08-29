import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/player_hitbox.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class FallingPlatform extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  FallingPlatform({super.position, super.size});

  final double fallSpeed = 10;
  final double _gravity = 9.8;
  final Duration _durationGravityApplied = const Duration(seconds: 1);
  late final Player player;
  late RectangleHitbox blockHitbox;
  Vector2 velocity = Vector2.zero();
  bool isDrop = false;

  CustomHitBox hitbox = CustomHitBox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    player = game.player;

    blockHitbox = RectangleHitbox(
      // position: Vector2(0, 0),
      // size: Vector2(32, 1),
      collisionType: CollisionType.passive,
    );

    add(blockHitbox);

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
  void update(double dt) {
    player.accumulatedTime += dt;
    while (player.accumulatedTime >= player.fixedDeltaTime) {
      _checkVerticalCollisions();
      player.accumulatedTime -= player.fixedDeltaTime;
    }

    if (isDrop) {
      velocity.y += _gravity;
      velocity.y = velocity.y.clamp(260, 300);
      position.y += velocity.y * dt;
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      collidingWithPlayer();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void collidingWithPlayer() async {
      print('colliding platform');

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Falling Platforms/Off.png'),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.05,
          textureSize: Vector2(32, 10),
        ),
      );

      Future.delayed(
        _durationGravityApplied,
        () {
          isDrop = true;
        },
      );
  }

  void _checkVerticalCollisions() {
    if (checkCollisionFallingPlatform(player, this)) {
      // print(x);
      // print(y);
      // print(width);
      // print(height);
      if (player.velocity.y > 0) {
        print(player.velocity.y);
        player.velocity.y = 0;
        // print(position.y);
        player.position.y = y - hitbox.height - hitbox.offsetY;
        player.isOnGround = true;
      }
    }
  }
}
