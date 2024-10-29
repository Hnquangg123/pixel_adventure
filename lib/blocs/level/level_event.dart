part of 'level_bloc.dart';


abstract class LevelEvent extends Equatable {
  const LevelEvent();
}

class BossStart extends LevelEvent {
  const BossStart();

  @override
  List<Object?> get props => throw UnimplementedError();
}
class BossKilled extends LevelEvent {
  const BossKilled();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReachChapterOne extends LevelEvent {
  const ReachChapterOne();

  @override
  List<Object?> get props => throw UnimplementedError();
}
class ReachChapterTwo extends LevelEvent {
  const ReachChapterTwo();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReachChapterThree extends LevelEvent {
  const ReachChapterThree();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReachChapterFour extends LevelEvent {
  const ReachChapterFour();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ReachChapterFive extends LevelEvent {
  const ReachChapterFive();

  @override
  List<Object?> get props => throw UnimplementedError();
}


