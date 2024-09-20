import 'dart:async';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/blocs/level/level_bloc.dart';
import 'package:pixel_adventure/blocs/score/score_bloc.dart';
import 'package:pixel_adventure/components/HUD/life_bar.dart';
import 'package:pixel_adventure/components/HUD/previous_button.dart';
import 'package:pixel_adventure/components/HUD/next_button.dart';
import 'package:pixel_adventure/components/HUD/restart_button.dart';
import 'package:pixel_adventure/components/HUD/score_bar.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/checkpoint_end.dart';
import 'package:pixel_adventure/components/enemies/skull.dart';
import 'package:pixel_adventure/components/enemies/chicken.dart';
import 'package:pixel_adventure/components/falling_plaform.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/HUD/volume_button.dart';
import 'package:pixel_adventure/components/spikes.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/choose_level_screen.dart';

class Level extends World
    with
        HasGameRef<PixelAdventure>,
        FlameBlocListenable<LevelBloc, LevelState> {
  final String levelName;
  Player player;
  final bool isChooseLevel;
  final ScoreBloc scoreBloc;
  Level({
    required this.levelName,
    required this.player,
    required this.isChooseLevel,
    required this.scoreBloc,
  });
  late JoystickComponent joystick;
  late TiledComponent level;
  late ChooseLevelScreen levelScreen;
  List<CollisionBlock> collisionBlock = [];

  @override
  FutureOr<void> onLoad() async {
    if (isChooseLevel) {
      levelScreen = ChooseLevelScreen();
      add(levelScreen);
    } else {
      level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

      if (game.playSounds) {
        if (game.currentLevelIndex == 10) {
          FlameAudio.bgm
              .play('Action 3 - Loop - Pure (Boss Fight).wav', volume: 0.25);
        } else if (game.currentLevelIndex < 10) {
          FlameAudio.bgm.play('Platformer 1 - Looped - Pure.wav', volume: 0.25);
        } else if (game.currentLevelIndex > 10 && game.currentLevelIndex < 20) {
          FlameAudio.bgm.play('Platformer 2 - Looped - Pure.wav', volume: 0.25);
        } else if (game.currentLevelIndex > 20 && game.currentLevelIndex < 30) {
          FlameAudio.bgm.play('Platformer 3 - Looped - Pure.wav', volume: 0.25);
        } else if (game.currentLevelIndex > 30 && game.currentLevelIndex < 40) {
          FlameAudio.bgm.play('Platformer 4 - Looped - Pure.wav', volume: 0.25);
        } else if (game.currentLevelIndex > 40 && game.currentLevelIndex < 50) {
          FlameAudio.bgm.play('Platformer 5 - Looped - Pure.wav', volume: 0.25);
        }
      }

      if (!game.playSounds) {
        FlameAudio.bgm.stop();
      }

      // _checkNextChapter();

      add(level);

      _addHud();
      _scrollingBackground();
      _spawningObject();
      _addCollision();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.showControls && !isChooseLevel) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 8, bottom: 48),
    );

    game.cam.viewport.addAll([
      joystick,
      JumpButton(levelSizeX: level.size.x, levelSizeY: level.size.y)
    ]);
    // addAll([joystick, JumpButton(level: this)]);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');

      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(0, 0),
      );

      add(backgroundTile);
    }
  }

  void _spawningObject() async {
    final spawmPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawmPointsLayer != null) {
      for (final spawnPoint in spawmPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            // if (game.changeCharacter) player = Player();
            print('handle player in map');
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            player.startingPosition = Vector2(spawnPoint.x, spawnPoint.y);
            player.character = spawnPoint.name;
            await add(
              FlameBlocProvider<ScoreBloc, ScoreState>.value(
                value: scoreBloc,
                children: [
                  player,
                ],
              ),
            );
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checkPoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );

            add(checkPoint);
            break;
          case 'Enemies':
            // add chicken
            switch (spawnPoint.name) {
              case 'Chicken':
                final offNeg = spawnPoint.properties.getValue('offNeg');
                final offPos = spawnPoint.properties.getValue('offPos');
                final chicken = Chicken(
                  enemyName: spawnPoint.name,
                  position: Vector2(spawnPoint.x, spawnPoint.y),
                  size: Vector2(spawnPoint.width, spawnPoint.height),
                  offNeg: offNeg,
                  offPos: offPos,
                );
                add(chicken);
                break;
              case 'Skull':
                final offNeg = spawnPoint.properties.getValue('offNeg');
                final offPos = spawnPoint.properties.getValue('offPos');
                final skullBoss = Skull(
                  position: Vector2(spawnPoint.x, spawnPoint.y),
                  size: Vector2(spawnPoint.width, spawnPoint.height),
                  offNeg: offNeg,
                  offPos: offPos,
                );
                add(skullBoss);
                break;
              default:
            }
            break;
          case 'Falling Platforms':
            // add chicken
            final fallingPlatform = FallingPlatform(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fallingPlatform);
            break;
          case 'Spikes':
            // add spikes
            final spikes = Spikes(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              isFlip: spawnPoint.properties.getValue('isFlip'),
            );
            add(spikes);
            break;
          case 'End':
            final checkPointEnd = CheckpointEnd(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            await add(
              FlameBlocProvider<LevelBloc, LevelState>.value(
                value: game.levelBloc,
                children: [
                  checkPointEnd,
                ],
              ),
            );
            break;
          default:
        }
      }
    }
  }

  void _addCollision() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: collision.size,
              isPlatform: true,
            );
            collisionBlock.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: collision.size,
            );
            collisionBlock.add(block);
            add(block);
            break;
        }
      }
    }

    player.collisionBlock = collisionBlock;
  }

  void _addHud() async {
    final volumeButton = VolumeButton(position: Vector2(600, 16));
    final nextButton = NextButton(position: Vector2(580, 16));
    final previousButton = PreviousButton(position: Vector2(560, 16));
    final restartButton = RestartButton(position: Vector2(540, 16));
    final lifeBar = LifeBar(size: Vector2.all(24));
    final scoreBar = ScoreBar(position: Vector2(20, 8));

    if (game.showControls && !isChooseLevel) {
      addJoyStick();
    }

    add(volumeButton);
    add(nextButton);
    add(previousButton);
    add(restartButton);
    await add(
      FlameBlocProvider<ScoreBloc, ScoreState>.value(
        value: scoreBloc,
        children: [
          lifeBar,
        ],
      ),
    );
    await add(
      FlameBlocProvider<ScoreBloc, ScoreState>.value(
        value: scoreBloc,
        children: [
          scoreBar,
        ],
      ),
    );
  }

  // void _checkNextChapter() {
  //   // Check whether reach next chapter to change character START
  //   if (game.currentLevelIndex <= 10 && game.changeCharacter) {
  //     game.reachChapterOne();
  //   }
  //   if (game.currentLevelIndex > 10 &&
  //       game.currentLevelIndex <= 20 &&
  //       game.changeCharacter) {
  //     print('lets change chapter two');
  //     game.reachChapterTwo();
  //   }
  //   if (game.currentLevelIndex > 20 &&
  //       game.currentLevelIndex <= 30 &&
  //       game.changeCharacter) {
  //     game.reachChapterThree();
  //   }
  //   if (game.currentLevelIndex > 30 &&
  //       game.currentLevelIndex <= 40 &&
  //       game.changeCharacter) {
  //     game.reachChapterFour();
  //   }
  //   if (game.currentLevelIndex > 40 &&
  //       game.currentLevelIndex <= 50 &&
  //       game.changeCharacter) {
  //     game.reachChapterFive();
  //   }
  //   // Check whether reach next chapter to change character END
  // }

  @override
  void onNewState(LevelState state) {
    print('state init');

    if (state.chapterOne && game.changeCharacter) {
      player = Player(character: 'Mask Dude');
      game.player = player;
      game.changeCharacter = false;
      log('say hello to mask dude! your level is: ${game.currentLevelIndex}');
    }
    if (state.chapterTwo && game.changeCharacter) {
      player = Player(character: 'Ninja Frog');
      game.player = player;
      game.changeCharacter = false;
      log('say hello to ninja frog! your level is: ${game.currentLevelIndex}');
    }
    if (state.chapterTwo && game.changeCharacter) {
      player = Player(character: 'Pink Man');
      game.player = player;
      game.changeCharacter = false;
    }
    if (state.chapterTwo && game.changeCharacter) {
      player = Player(character: 'Virtual Guy');
      game.player = player;
      game.changeCharacter = false;
    }
    if (state.chapterTwo && game.changeCharacter) {
      player = Player(character: 'Mask Dude');
      game.player = player;
      game.changeCharacter = false;
    }

    super.onInitialState(state);
  }
}
