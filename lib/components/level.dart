import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/blocs/score/score_bloc.dart';
import 'package:pixel_adventure/components/HUD/life_bar.dart';
import 'package:pixel_adventure/components/HUD/previous_button.dart';
import 'package:pixel_adventure/components/HUD/next_button.dart';
import 'package:pixel_adventure/components/HUD/restart_button.dart';
import 'package:pixel_adventure/components/HUD/score_bar.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/enemies/skull.dart';
import 'package:pixel_adventure/components/enemies/chicken.dart';
import 'package:pixel_adventure/components/falling_plaform.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/HUD/volume_button.dart';
import 'package:pixel_adventure/components/spikes.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/choose_level_screen.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  final bool isChooseLevel;
  final ScoreBloc scoreBloc;
  Level({
    required this.levelName,
    required this.player,
    required this.isChooseLevel,
    required this.scoreBloc,
  });
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
        } else {
          FlameAudio.bgm
              .play('1-06. Dungeon (Spelunker Theme).mp3', volume: 0.25);
        }
      }

      if (!game.playSounds) {
        FlameAudio.bgm.stop();
      }

      add(level);

      _addHud();
      _scrollingBackground();
      _spawningObject();
      _addCollision();
    }

    return super.onLoad();
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
      for (final spawnPoint in spawmPointsLayer!.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            player.startingPosition = Vector2(spawnPoint.x, spawnPoint.y);
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
}
