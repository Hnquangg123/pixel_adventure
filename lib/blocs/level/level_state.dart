part of 'level_bloc.dart';

enum GameStatus {
  initial,
  bossOver,
}

class LevelState extends Equatable {
  final GameStatus status;
  final bool chapterOne;
  final bool chapterTwo;
  final bool chapterThree;
  final bool chapterFour;
  final bool chapterFive;

  const LevelState({
    required this.status,
    required this.chapterOne,
    required this.chapterTwo,
    required this.chapterThree,
    required this.chapterFour,
    required this.chapterFive,
  });

  const LevelState.empty()
      : this(
          status: GameStatus.initial,
          chapterOne: false,
          chapterTwo: false,
          chapterThree: false,
          chapterFour: false,
          chapterFive: false,
        );

  LevelState copyWith({
    GameStatus? status,
    bool? chapterOne,
    bool? chapterTwo,
    bool? chapterThree,
    bool? chapterFour,
    bool? chapterFive,
  }) {
    return LevelState(
      status: status ?? this.status,
      chapterOne: chapterOne ?? this.chapterOne,
      chapterTwo: chapterTwo ?? this.chapterTwo,
      chapterThree: chapterThree ?? this.chapterThree,
      chapterFour: chapterFour ?? this.chapterFour,
      chapterFive: chapterFive ?? this.chapterFive,
    );
  }

  GameStatus bossStart() {
    return GameStatus.initial;
  }
  GameStatus bossOver() {
    return GameStatus.bossOver;
  }

  bool isBossOver(gameStatus) {
    return gameStatus == GameStatus.bossOver;
  }

  @override
  List<Object?> get props => [status, chapterOne, chapterTwo, chapterThree, chapterFour, chapterFive];
}
