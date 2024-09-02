import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class VolumeButton extends SpriteComponent
    with TapCallbacks, HasGameRef<PixelAdventure> {
  VolumeButton({super.position, super.size});

  late final Sprite _on;
  late final Sprite _off;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    _loadImageState();

    sprite = game.playSounds ? _on : _off;

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.playSounds = !game.playSounds;

    if (game.playSounds) {
      if (!FlameAudio.bgm.isPlaying) {
        // print(game.currentLevelIndex);
        if (game.currentLevelIndex == 10) {
          FlameAudio.bgm
              .play('Action 3 - Loop - Pure (Boss Fight).wav', volume: 0.25);
        } else {
          FlameAudio.bgm
              .play('1-06. Dungeon (Spelunker Theme).mp3', volume: 0.25);
        }
      }
    }

    if (!game.playSounds) {
      if (FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.stop();
      }
    }

    sprite = game.playSounds ? _on : _off;
    ;

    super.onTapDown(event);
  }

  void _loadImageState() {
    _on = Sprite(
      game.images.fromCache('Menu/Buttons/Volume.png'),
    );
    _off = Sprite(game.images.fromCache('Menu/Buttons/Volume Off.png'));
  }
}
