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

  final fixedX = player.scale.x < 0 ? playerX - (hitbox.offsetX * 2) - playerWidth : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
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

  final fixedX = player.scale.x < 0 ? playerX - (hitbox.offsetX * 2) - playerWidth : playerX;
  final fixedY = playerY + playerHeight;

  return (fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}


