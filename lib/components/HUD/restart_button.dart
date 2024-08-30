import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class RestartButton extends SpriteComponent
    with TapCallbacks, HasGameRef<PixelAdventure> {
  RestartButton({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    sprite = Sprite(game.images.fromCache('Menu/Buttons/Restart.png'),);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    
    // Refresh current level
    game.restartLevel();

    super.onTapDown(event);
  }


}
