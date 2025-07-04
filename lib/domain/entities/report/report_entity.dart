class LearningReportEntity {
  final TotalReportEntity weeklyReport;
  final TotalReportEntity totalLearned;
  final RecentWeeklyReportEntity recentWeeklyReport;
  final LevelProgressEntity levelProgress;
  final String? stageFocusLearnToRead;
  final String? stageFocusEarlyReader;

  LearningReportEntity({
    required this.weeklyReport,
    required this.totalLearned,
    required this.recentWeeklyReport,
    required this.levelProgress,
    this.stageFocusLearnToRead,
    this.stageFocusEarlyReader,
  });
}

class TotalReportEntity {
  final GeneralReportEntity generalReport;
  final Map<String, int> storyByLevel;

  TotalReportEntity({required this.generalReport, required this.storyByLevel});
}

class GeneralReportEntity {
  final int totalStory;
  final int totalLesson;
  final int totalVideo;
  final int totalAudioBook;
  final int totalDuration;

  GeneralReportEntity({
    this.totalStory = 0,
    this.totalLesson = 0,
    this.totalVideo = 0,
    this.totalAudioBook = 0,
    this.totalDuration = 0,
  });
}

class RecentWeeklyReportEntity {
  final int week1;
  final int week2;
  final int week3;
  final int week4;

  RecentWeeklyReportEntity({
    this.week1 = 0,
    this.week2 = 0,
    this.week3 = 0,
    this.week4 = 0,
  });
}

class ProgressEntity {
  final int current;
  final int total;

  const ProgressEntity({this.current = 0, this.total = 1});
}

class LevelProgressEntity {
  final ProgressEntity one;
  final ProgressEntity two;
  final ProgressEntity three;
  final ProgressEntity four;
  final ProgressEntity five;
  final ProgressEntity six;
  final ProgressEntity seven;

  const LevelProgressEntity({
    this.one = const ProgressEntity(),
    this.two = const ProgressEntity(),
    this.three = const ProgressEntity(),
    this.four = const ProgressEntity(),
    this.five = const ProgressEntity(),
    this.six = const ProgressEntity(),
    this.seven = const ProgressEntity(),
  });
}
