part of 'level_bloc.dart';

enum GameStatus {
  initial,
  gameOver,
}

class LevelState extends Equatable {
  final GameStatus status;

  const LevelState({
    required this.status,
  });

  const LevelState.empty()
      : this(
          status: GameStatus.initial,
        );

  LevelState copyWith({
    GameStatus? status,
  }) {
    return LevelState(
      status: status ?? this.status,
    );
  }

  GameStatus gameOver() {
    return GameStatus.gameOver;
  }

  bool isGameOver(gameStatus) {
    return gameStatus == GameStatus.gameOver;
  }

  @override
  List<Object?> get props => [status];
}
