bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerHeight = hitbox.height;
  final playerWidth = hitbox.width;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  // bool collision = fixedY < blockY + blockHeight &&
  //     playerY + playerHeight > blockY &&
  //     fixedX < blockX + blockWidth &&
  //     fixedX + playerWidth > blockX;
  // print(collision);
  // print(player.velocity);

  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}

bool checkVerticalCollision(player, block) {
  final hitbox = player.hitbox;
  final playerY = player.position.y + hitbox.offsetY;
  final playerHeight = hitbox.height;

  final blockY = block.y;
  final blockHeight = block.height;

  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight && playerY + playerHeight > blockY);
}

bool checkHorizontalCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerWidth = hitbox.width;

  final blockX = block.x;
  final blockWidth = block.width;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;

  return (fixedX < blockX + blockWidth && fixedX + playerWidth > blockX);
}

bool checkCollisionFallingPlatform(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerHeight = hitbox.height;
  final playerWidth = hitbox.width;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = playerY + playerHeight;

  return (fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
