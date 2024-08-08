import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class NextButton extends SpriteComponent
    with TapCallbacks, HasGameRef<PixelAdventure> {
  NextButton({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    sprite = Sprite(game.images.fromCache('Menu/Buttons/Next.png'),);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    
    game.loadNextLevel();

    super.onTapDown(event);
  }


}
