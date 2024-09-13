import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/falling_plaform.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State { idle1, idle2, transform1, transform2, hit }

class Skull extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  final double offPos;
  final double offNeg;

  Skull({
    super.position,
    super.size,
    required this.offPos,
    required this.offNeg,
  });

  static const stepTime = 0.05;
  static const movementSpeed = 50;
  static const _bounceHeight = 260.0;
  double rangeNeg = 0;
  double rangePos = 0;
  double tileSize = 16;
  double moveDirection = -1;
  bool init = false;
  final initStandByDuration = const Duration(seconds: 3);
  final explodeDuration = const Duration(milliseconds: 1000);
  final vanishDuration = const Duration(milliseconds: 1500);

  Timer? spawnTimer;
  final spawnDuration = const Duration(milliseconds: 500);

  final Random _rnd = Random();

  Vector2 randomVector2() => (Vector2.random(_rnd) - Vector2(0.5, 1)) * 180;

  late final Player player;
  late final SpriteAnimation _idleAnimation1;
  late final SpriteAnimation _idleAnimation2;
  late final SpriteAnimation _transformAnimation1;
  late final SpriteAnimation _transformAnimation2;
  late final SpriteAnimation _hitAnimation;

  late final CircleHitbox onFireHitBox = CircleHitbox();
  late final CircleHitbox offFireHitBox = CircleHitbox(
      radius: onFireHitBox.radius / 1.5, position: Vector2(7, 13.5));

  // boss state
  bool gotHit = false;
  bool invincible = false;
  int live = 2;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    player = game.player;

    add(onFireHitBox);

    rangeNeg = position.x - (offNeg - 3) * tileSize;
    rangePos = position.x + offPos * tileSize;

    flipHorizontallyAroundCenter();

    _loadAllAnimations();

    _addSkullParticles();

    // Spawn particles again after 1 second
    spawnTimer = Timer.periodic(spawnDuration, (_) {
      _addSkullParticles();
    });

    Future.delayed(
      initStandByDuration,
      () => init = true,
    );

    return super.onLoad();
  }


  @override
  void update(double dt) {
    // if (init && live > 0) {
    //   Future.delayed(
    //     Duration(seconds: 3),
    //     () => _updateMovement(dt),
    //   );
    // } else {
    //   if (live > 0) {
    //     _updateMovement(dt);
    //   }
    // }

    if (live > 0 && init) {
      _updateMovement(dt);
    }

    // _updateState();

    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation1 = _spriteAnimation('Idle 1 (52x54)', 8);
    _idleAnimation2 = _spriteAnimation('Idle 2 (52x54)', 8);
    _transformAnimation1 = _spriteAnimation('Hit Wall 1 (52x54)', 7)
      ..loop = false;
    _transformAnimation2 = _spriteAnimation('Hit Wall 2 (52x54)', 7)
      ..loop = false;
    _hitAnimation = _spriteAnimation('Hit (52x54)', 5)..loop = false;

    animations = {
      State.idle1: _idleAnimation1,
      State.idle2: _idleAnimation2,
      State.transform1: _transformAnimation1,
      State.transform2: _transformAnimation2,
      State.hit: _hitAnimation,
    };

    current = State.idle1;
  }

  void _updateMovement(dt) {
    if (position.x <= rangeNeg) {
      moveDirection = 1;
    } else if (position.x >= rangePos) {
      moveDirection = -1;
    }

    if (moveDirection * movementSpeed < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    }

    if (moveDirection * movementSpeed > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    position.x += moveDirection * movementSpeed * dt;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Skull/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(52, 54),
      ),
    );
  }

  void _addSkullParticles() {
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: 2,
        lifespan: 0.8,
        generator: (p0) => AcceleratedParticle(
          position: Vector2(39 - p0.toDouble() * 26, 45),
          acceleration: randomVector2(),
          speed: Vector2(0.5, 1),
          child: ImageParticle(
              image: game.images.fromCache('Enemies/Skull/Red Particle.png')),
        ),
      ),
      size: Vector2.all(16),
    ));
  }

  void _addSkullParticlesOnDeath() {
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: 72,
        lifespan: 4,
        generator: (p0) => AcceleratedParticle(
          position: Vector2(26, 40),
          acceleration: randomVector2(),
          speed: Vector2(0.5, 1),
          child: ImageParticle(
              image: game.images.fromCache('Enemies/Skull/Red Particle.png')),
        ),
      ),
      size: Vector2.all(16),
    ));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is FallingPlatform && !gotHit) {
      collingWithFallingPlatform();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void collingWithFallingPlatform() async {
    gotHit = true;

    current = State.transform2;

    await animationTicker?.completed;
    animationTicker?.reset();

    current = State.idle2;

    spawnTimer?.cancel();

    remove(onFireHitBox);
    add(offFireHitBox);

    Future.delayed(
      const Duration(seconds: 4),
      () async {
        if (gotHit) {
          spawnTimer = Timer.periodic(spawnDuration, (_) {
            _addSkullParticles();
          });
          gotHit = false;
          invincible = false;

          current = State.transform1;

          await animationTicker?.completed;
          animationTicker?.reset();

          current = State.idle1;

          remove(offFireHitBox);
          add(onFireHitBox);
        }
      },
    );
  }

  void collidingWithPlayer() async {
    if (!invincible &&
        player.velocity.y > 0 &&
        player.y + player.height > position.y &&
        gotHit) {
      if (game.playSounds) {
        FlameAudio.play('bounce.wav', volume: game.soundVolume);
      }

      live--;

      if (live > 0) {
        current = State.hit;
        invincible = true;
        player.velocity.y = -_bounceHeight;
        await animationTicker?.completed;
        animationTicker?.reset();
      }

      if (live == 0) {
        current = State.hit;
        _hitAnimation.loop = true;
        gotHit = false;
        invincible = true;
        player.velocity.y = -_bounceHeight;

        Future.delayed(
          explodeDuration,
          () => _hitAnimation.loop = false,
        );

        await animationTicker?.completed;
        animationTicker?.reset();

        if (game.playSounds) {
          FlameAudio.play('explosion.wav', volume: game.soundVolume);
        }
        _addSkullParticlesOnDeath();

        Future.delayed(
          vanishDuration,
          () {
            if (game.playSounds) {
              FlameAudio.bgm.stop();
            }
            removeFromParent();
          },
        );
      }

      current = State.idle2;
    } else {
      if (!invincible) {
        player.collidedWithEnemy();
      }
    }
  }

  // void _updateState() {

  // }
}
