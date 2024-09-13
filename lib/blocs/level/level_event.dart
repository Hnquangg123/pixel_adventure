part of 'level_bloc.dart';


abstract class LevelEvent extends Equatable {
  const LevelEvent();
}

class BossKilled extends LevelEvent {
  const BossKilled();

  @override
  List<Object?> get props => throw UnimplementedError();
}


