bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerHeight = player.height;
  final playerWidth = player.width;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
