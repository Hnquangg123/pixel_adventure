import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'level_event.dart';
part 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc() : super(const LevelState.empty()) {
    on<BossKilled>(
      (event, emit) => emit(
        state.copyWith(status: state.bossOver()),
      ),
    );
    on<ReachChapterOne>(
      (event, emit) => emit(
        state.copyWith(
          chapterOne: true,
          chapterTwo: false,
          chapterThree: false,
          chapterFour: false,
          chapterFive: false,
        ),
      ),
    );
    on<ReachChapterTwo>(
      (event, emit) => emit(
        state.copyWith(
          chapterOne: false,
          chapterTwo: true,
          chapterThree: false,
          chapterFour: false,
          chapterFive: false,
        ),
      ),
    );
    on<ReachChapterThree>(
      (event, emit) => emit(
        state.copyWith(
          chapterOne: false,
          chapterTwo: false,
          chapterThree: true,
          chapterFour: false,
          chapterFive: false,
        ),
      ),
    );
    on<ReachChapterFour>(
      (event, emit) => emit(
        state.copyWith(
          chapterOne: false,
          chapterTwo: false,
          chapterThree: false,
          chapterFour: true,
          chapterFive: false,
        ),
      ),
    );
    on<ReachChapterFive>(
      (event, emit) => emit(
        state.copyWith(
          chapterOne: false,
          chapterTwo: false,
          chapterThree: false,
          chapterFour: false,
          chapterFive: true,
        ),
      ),
    );
  }
}
