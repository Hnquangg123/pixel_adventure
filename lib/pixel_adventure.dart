import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/blocs/level/level_bloc.dart';
import 'package:pixel_adventure/blocs/score/score_bloc.dart';
import 'package:pixel_adventure/components/HUD/score_bar.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/screens/choose_level_screen.dart';
import 'package:pixel_adventure/screens/game_over_screen.dart';
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
  late GameOverScreen gameOverScreen;
  late ScoreBar scoreBar;
  bool firstStart = true;

  late ScoreBloc scoreBloc;
  late LevelBloc levelBloc;

  late Player player;
  late CameraComponent cam;
  // late JoystickComponent joystick;
  bool showControls = true;
  bool playSounds = false;
  double soundVolume = 1.0;
  bool changeCharacter = false;
  List<String> levelNames = [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
    'Level-05',
    'Level-06',
    'Level-07',
    'Level-08',
    'Level-09',
    'Level-10',
    'Level-11',
  ];
  int levelLength = 0;
  int currentLevelIndex = 0;

  int gamePoint = 0;
  int lifePoint = 2;

  @override
  FutureOr<void> onLoad() async {
    WidgetsBinding.instance.addObserver(this);

    // Load all images into cache
    await images.loadAllImages();
    // await FlameAudio.audioCache.load('bgm.mp3');
    FlameAudio.bgm.initialize;
    FlameAudio.audioCache.loadAll;

    priority = 0;

    // Init Player
    player = Player();

    // Init Bloc
    scoreBloc = ScoreBloc();
    levelBloc = LevelBloc();
    // scoreBar = ScoreBar(position: Vector2(99, 99));

    // add Bloc to manage score
    // await add(FlameBlocProvider<ScoreBloc, ScoreState>.value(
    //   value: scoreBloc,
    //   children: [
    //     scoreBar,
    //   ],
    // ));

    startScreen = StartScreen(
      onStart: () => _loadLevel(true),
    );
    // startScreen = StartScreen(onStart: _loadLevelScreen);

    loadScreen = LoadScreen();

    add(startScreen);

    if (playSounds) {
      FlameAudio.bgm.play('1-01. Title Screen.mp3', volume: 0.25);
    }

    // if (showControls) {
    //   addJoyStick();
    // }

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
      if (playSounds) {
        FlameAudio.bgm.resume();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  // @override
  // void update(double dt) {
  //   if (showControls) {
  //     updateJoyStick();
  //   }
  //   super.update(dt);
  // }

  // void addJoyStick() {
  //   joystick = JoystickComponent(
  //     knob: SpriteComponent(
  //       sprite: Sprite(
  //         images.fromCache('HUD/Knob.png'),
  //       ),
  //     ),
  //     background: SpriteComponent(
  //       sprite: Sprite(
  //         images.fromCache('HUD/Joystick.png'),
  //       ),
  //     ),
  //     margin: const EdgeInsets.only(left: 32, bottom: 32),
  //   );

  //   // cam.viewport.addAll([joystick, JumpButton()]);
  //   addAll([joystick, JumpButton()]);
  // }

  // void updateJoyStick() {
  //   switch (joystick.direction) {
  //     case JoystickDirection.left:
  //     case JoystickDirection.upLeft:
  //     case JoystickDirection.downLeft:
  //       player.horizontalMovement = -1;
  //       break;
  //     case JoystickDirection.right:
  //     case JoystickDirection.upRight:
  //     case JoystickDirection.downRight:
  //       player.horizontalMovement = 1;
  //       break;
  //     default:
  //       player.horizontalMovement = 0;
  //       break;
  //   }
  // }

  Future<void> gameOver() async {
    removeWhere(
      (component) => component is FlameBlocProvider,
    );

    FlameAudio.bgm.stop();
    if (playSounds) {
      FlameAudio.play('game_over.wav', volume: soundVolume);
    }

    gameOverScreen = GameOverScreen(
      onStart: () async {
        await loadNewStart();
      },
    );
    scoreBloc.add(const GameReset());
    await add(gameOverScreen);
  }

  // void _clickGameOver() {
  //   remove(gameOverScreen);
// }

  void loadNextLevel() {
    removeWhere(
      (component) => component is FlameBlocProvider,
    );

    // if (currentLevelIndex < levelLength) {
    if (currentLevelIndex < levelNames.length) {
      currentLevelIndex++;
      _loadLevel(false);
    } else {
      currentLevelIndex = 1;
      _loadLevel(false);
    }
  }

  void restartLevel() {
    removeWhere(
      (component) => component is FlameBlocProvider,
    );

    _loadLevel(false);
  }

  void loadPreviousLevel() {
    removeWhere(
      (component) => component is FlameBlocProvider,
    );

    // if (currentLevelIndex < levelLength) {
    if (currentLevelIndex > 1) {
      currentLevelIndex--;
      _loadLevel(false);
    } else {
      currentLevelIndex = 1;
      _loadLevel(false);
    }
  }

  void _loadLevel(bool isChooseLevel) {
    if (firstStart) {
      remove(startScreen);
      firstStart = false;
      FlameAudio.bgm.stop();
    }

    // Handle character change for each chapter
    if (currentLevelIndex <= 10 && player.character != 'Mask Dude') {
        changeCharacter = true;
        print('this is mask dude, your system character before changing: ' + player.character);
        reachChapterOne();
    }
    if (currentLevelIndex > 10 && currentLevelIndex <= 20 && player.character != 'Ninja Frog') {
        changeCharacter = true;
        print('this is ninja frog, your system character before changing: ' + player.character);
        reachChapterTwo();
    }
    if (currentLevelIndex > 20 && currentLevelIndex <= 30 && player.character != 'Pink Man') {
        changeCharacter = true;
        reachChapterThree();
    }
    if (currentLevelIndex > 30 && currentLevelIndex <= 40 && player.character != 'Virtual Guy') {
        changeCharacter = true;
        reachChapterFour();
    }
    if (currentLevelIndex > 40 && currentLevelIndex <= 50 && player.character != 'Mask Dude') {
        changeCharacter = true;
        reachChapterFive();
    }

    // if (!isChooseLevel) {
    // }
    add(loadScreen);

    Future.delayed(
      const Duration(seconds: 1),
      () {
        Level world = Level(
          levelName: currentLevelIndex < 10
              ? 'Level-0$currentLevelIndex'
              : 'Level-$currentLevelIndex',
          player: player,
          isChooseLevel: isChooseLevel,
          scoreBloc: scoreBloc,
        );

        cam = CameraComponent.withFixedResolution(
            width: 640, height: 360, world: world);

        cam.viewfinder.anchor = Anchor.topLeft;
        // if (!isChooseLevel) {
        // }
        remove(loadScreen);
        addAll([
          cam,
          FlameBlocProvider<LevelBloc, LevelState>.value(
            value: levelBloc,
            children: [
              world,
            ],
          ),
        ]);
      },
    );
  }

  void loadLevelFromChoosing(String level, int levelIndex) {
    add(loadScreen);

    Future.delayed(
      const Duration(seconds: 1),
      () async {
        Level world = Level(
          levelName: 'Level-$level',
          player: player,
          isChooseLevel: false,
          scoreBloc: scoreBloc,
        );

        currentLevelIndex = levelIndex;

        cam = CameraComponent.withFixedResolution(
            width: 640, height: 360, world: world);

        cam.viewfinder.anchor = Anchor.topLeft;
        remove(loadScreen);
        await addAll([
          cam,
          FlameBlocProvider<LevelBloc, LevelState>.value(
            value: levelBloc,
            children: [
              world,
            ],
          ),
        ]);
      },
    );
  }

  void showLevelSelection() {
    remove(startScreen);
    // create level selection screen and add it into the game
  }

  FutureOr<void> loadNewStart() async {
    remove(gameOverScreen);
    firstStart = true;

    // Init Player
    player = Player(character: 'Mask Dude');

    // Init ScoreBar & Bloc
    scoreBloc = ScoreBloc();
    levelBloc = LevelBloc();
    // scoreBar = ScoreBar(position: Vector2(99, 99));

    // add Bloc to manage score
    // await add(FlameBlocProvider<ScoreBloc, ScoreState>.value(
    //   value: scoreBloc,
    //   children: [
    //     scoreBar,
    //   ],
    // ));

    startScreen = StartScreen(
      onStart: () => _loadLevel(true),
    );
    // startScreen = StartScreen(onStart: _loadLevelScreen);

    loadScreen = LoadScreen();

    add(startScreen);

    if (playSounds) {
      FlameAudio.bgm.play('1-01. Title Screen.mp3', volume: 0.25);
    }
  }

  // Manage State Score & Life

  void increaseScore(int scoreIncreasing) {
    scoreBloc.add(ScoreEventAdded(scoreIncreasing));
  }

  void increaseLife(bool scoreIncreasing) {
    int liveIncreaseCount = scoreIncreasing ? 1 : 0;
    scoreBloc.add(LifeEventAdded(1, liveIncreaseCount));
  }

  void decreaseLife() {
    scoreBloc.add(const PlayerDie());
  }

  // Manage State Level

  void bossStart() {
    levelBloc.add(const BossStart());
  }

  void bossKilled() {
    levelBloc.add(const BossKilled());
  }

  void reachChapterOne() {
    levelBloc.add(const ReachChapterOne());
  }

  void reachChapterTwo() {
    levelBloc.add(const ReachChapterTwo());
  }

  void reachChapterThree() {
    levelBloc.add(const ReachChapterThree());
  }

  void reachChapterFour() {
    levelBloc.add(const ReachChapterFour());
  }
  
  void reachChapterFive() {
    levelBloc.add(const ReachChapterFive());
  }

  // void _loadLevelScreen() {
  //   if (firstStart) {
  //     remove(startScreen);
  //     levelScreen = ChooseLevelScreen();
  //     add(levelScreen);
  //     firstStart = false;
  //     FlameAudio.bgm.stop();
  //   }
  // }
}
