import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc() : super(const ScoreState.empty()) {
    on<ScoreEventAdded>(
      (event, emit) => emit(
        state.copyWith(score: state.score + event.score),
      ),
    );

    on<PlayerRespawned>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.respawned),
      ),
    );

    on<PlayerDie>((event, emit) {
      if (state.live > 1) {
        emit(
          state.copyWith(
            live: state.live - 1,
            status: GameStatus.respawn,
          ),
        );
      } else {
        emit(
          state.copyWith(
            live: 0,
            status: GameStatus.gameOver,
          ),
        );
      }
    });

    on<GameReset>(
      (event, emit) => emit(
        const ScoreState.empty(),
      ),
    );
  }
}
