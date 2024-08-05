import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/screens/choose_level_screen.dart';
import 'package:pixel_adventure/screens/load_screen.dart';
import 'package:pixel_adventure/screens/start_screen.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks,
        WidgetsBindingObserver {
  @override
  Color backgroundColor() => const Color(0xFF211f30);

  late StartScreen startScreen;
  late LoadScreen loadScreen;
  late ChooseLevelScreen levelScreen;
  bool firstStart = true;

  Player player = Player(character: 'Mask Dude');
  late CameraComponent cam;
  late JoystickComponent joystick;
  bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
    'Level-05',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    WidgetsBinding.instance.addObserver(this);

    // Load all images into cache
    await images.loadAllImages();
    // await FlameAudio.audioCache.load('bgm.mp3');
    FlameAudio.bgm.initialize;
    FlameAudio.audioCache.loadAll;

    // startScreen = StartScreen(onStart: _loadLevel);
    startScreen = StartScreen(onStart: _loadLevelScreen);

    loadScreen = LoadScreen();

    add(startScreen);

    if (playSounds) {
      FlameAudio.bgm.play('1-01. Title Screen.mp3', volume: 0.25);
    }

    // _loadLevel();

    if (showControls) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void onRemove() {
    FlameAudio.bgm.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onRemove();
  }

  // when app on background stop music or resume it when app on screen
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      FlameAudio.bgm.pause();
    } else if (state == AppLifecycleState.resumed) {
      FlameAudio.bgm.resume();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    // cam.viewport.addAll([joystick, JumpButton()]);
    addAll([joystick, JumpButton()]);
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

  void loadNextLevel() {
    removeWhere(
      (component) => component is Level,
    );

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    if (firstStart) {
      remove(startScreen);
      firstStart = false;
      FlameAudio.bgm.stop();
    }
    add(loadScreen);

    Future.delayed(
      const Duration(seconds: 1),
      () {
        Level world = Level(
          levelName: levelNames[currentLevelIndex],
          player: player,
        );

        cam = CameraComponent.withFixedResolution(
            width: 640, height: 360, world: world);

        cam.viewfinder.anchor = Anchor.topLeft;

        addAll([cam, world]);
      },
    );
  }

  void loadLevelFromChoosing(String level, int levelIndex) {

    add(loadScreen);

    Future.delayed(
      const Duration(seconds: 1),
      () {
        Level world = Level(
          levelName: 'Level-$level',
          player: player,
        );

        currentLevelIndex = levelIndex;

        cam = CameraComponent.withFixedResolution(
            width: 640, height: 360, world: world);

        cam.viewfinder.anchor = Anchor.topLeft;

        addAll([cam, world]);
      },
    );
  }

  void showLevelSelection() {
    remove(startScreen);
    // create level selection screen and add it into the game
  }

  void _loadLevelScreen() {
    if (firstStart) {
      remove(startScreen);
      levelScreen = ChooseLevelScreen(player: player);
      add(levelScreen);
      firstStart = false;
      FlameAudio.bgm.stop();
    }
  }
}
