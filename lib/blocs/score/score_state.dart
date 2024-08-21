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
  final int liveIncreaseCount;
  final GameStatus status;

  const ScoreState({
    required this.score,
    required this.live,
    required this.liveIncreaseCount,
    required this.status,
  });

  const ScoreState.empty()
      : this(
          score: 0,
          live: 3,
          liveIncreaseCount: 1,
          status: GameStatus.initial,
        );

  ScoreState copyWith({
    int? score,
    int? live,
    int? liveIncreaseCount,
    GameStatus? status,
  }) {
    return ScoreState(
      score: score ?? this.score,
      live: live ?? this.live,
      liveIncreaseCount: liveIncreaseCount ?? this.liveIncreaseCount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [score, live, status];
}
