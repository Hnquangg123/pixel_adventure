part of 'score_bloc.dart';

enum GameStatus {
  initial,
  respawn,
  respawned,
  gameOver,
}

class ScoreState extends Equatable {
  final int score;
  final int live;
  final GameStatus status;

  const ScoreState({
    required this.score,
    required this.live,
    required this.status,
  });

  const ScoreState.empty()
      : this(
          score: 0,
          live: 3,
          status: GameStatus.initial,
        );

  ScoreState copyWith({
    int? score,
    int? live,
    GameStatus? status,
  }) {
    return ScoreState(
      score: score ?? this.score,
      live: live ?? this.live,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [score, live, status];
}
