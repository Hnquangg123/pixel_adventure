import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent with HasCollisionDetection {
  
  bool isPlatform;

  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(
          position: position,
          size: size,
        ) {
          // debugMode = true;
        }
}
