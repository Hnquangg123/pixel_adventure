part of 'score_bloc.dart';

abstract class ScoreEvent extends Equatable {
  const ScoreEvent();
}

class ScoreEventAdded extends ScoreEvent {
  const ScoreEventAdded(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}

class LifeEventAdded extends ScoreEvent {
  const LifeEventAdded(this.live, this.liveIncreaseCount);

  final int live;
  final int liveIncreaseCount;

  @override
  List<Object?> get props => [live, liveIncreaseCount];
}

class PlayerDie extends ScoreEvent {
  const PlayerDie();

  @override
  List<Object?> get props => [];
}

class PlayerRespawned extends ScoreEvent {
  const PlayerRespawned();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class GameReset extends ScoreEvent {
  const GameReset();

  @override
  List<Object?> get props => throw UnimplementedError();
}
