import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'level_event.dart';
part 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc() : super(const LevelState.empty()) {

    on<BossKilled>(
      (event, emit) => emit(
        state.copyWith(status: state.gameOver()),
      ),
    );
  }
}
