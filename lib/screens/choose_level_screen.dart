import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/components/level_button.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/screens/load_screen.dart';

class ChooseLevelScreen extends PositionComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  ChooseLevelScreen();
  late TiledComponent levelBoard;

  late LoadScreen loadScreen;
  late LevelButton levelButton;
  late ButtonComponent button;

  bool firstStart = true;

  @override
  FutureOr<void> onLoad() async {
    levelBoard = await TiledComponent.load("Choose-Level.tmx", Vector2.all(16));

    // debugMode = true;

    add(levelBoard);

    _addLevelNumber();

    return super.onLoad();
  }

  void _addLevelNumber() {
    final groupLevel = levelBoard.tileMap.getLayer<ObjectGroup>('LevelGroup');

    if (groupLevel != null) {

      game.levelLength = groupLevel.objects.length;

      for (final spawnPoint in groupLevel!.objects) {
        switch (spawnPoint.class_) {
          case 'Level':
            // add text component render with spritefont
            levelButton = LevelButton(
              // size: Vector2(spawnPoint.width, spawnPoint.height),
              position: spawnPoint.name == '?' ? Vector2(8,6) : Vector2(0, 6), // Font scale x2 so 20, block size 32 so middle = 6
              text: spawnPoint.name,
            );

            button = ButtonComponent(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              button: levelButton,
              onPressed: () => spawnPoint.name != '?' ? _loadLevel(spawnPoint.name, spawnPoint.id) : null,
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
