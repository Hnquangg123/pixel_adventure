import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/level_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/load_screen.dart';

class ChooseLevelScreen extends PositionComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  ChooseLevelScreen({required this.player});
  late TiledComponent levelBoard;

  late LoadScreen loadScreen;
  late LevelButton levelButton;
  late ButtonComponent button;
  Player player;
  late CameraComponent cam;

  bool firstStart = true;

  @override
  FutureOr<void> onLoad() async {
    levelBoard = await TiledComponent.load("Choose-Level.tmx", Vector2.all(32));

    // debugMode = true;

    add(levelBoard);

    _addLevelNumber();
    _scrollingBackground();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = levelBoard.tileMap.getLayer('Background');

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

  void _addLevelNumber() {
    final groupLevel = levelBoard.tileMap.getLayer<ObjectGroup>('LevelGroup');

    if (groupLevel != null) {
      for (final spawnPoint in groupLevel!.objects) {
        switch (spawnPoint.class_) {
          case 'Level':
            // add text component render with spritefont
            levelButton = LevelButton(
              size: Vector2(spawnPoint.width, spawnPoint.height),
              position: Vector2(spawnPoint.x + 4, spawnPoint.y + 8),
              text: spawnPoint.name,
              onPressed: () => _loadLevel(spawnPoint.name, spawnPoint.id),
            );

            button = ButtonComponent(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              button: levelButton,
            );

            add(button);
            break;
          default:
        }
      }
    }
  }

  void _loadLevel(String level, int levelIndex) {
    if (firstStart) {
      FlameAudio.bgm.stop();

      removeWhere(
        (component) => component is ButtonComponent,
      );

      remove(levelBoard);
    }

    game.loadLevelFromChoosing(level, levelIndex);
  }
}
