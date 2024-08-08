import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PreviousButton extends SpriteComponent
    with TapCallbacks, HasGameRef<PixelAdventure> {
  PreviousButton({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    sprite = Sprite(game.images.fromCache('Menu/Buttons/Previous.png'),);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    
    // Move to previous level
    game.loadPreviousLevel();

    super.onTapDown(event);
  }


}
