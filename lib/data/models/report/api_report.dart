// Project imports:
import 'package:monkey_stories/core/constants/lesson.dart';
import 'package:monkey_stories/domain/entities/report/report_entity.dart';

class ApiReportResponse {
  final TotalReport weeklyReport;
  final TotalReport totalLearned;
  final RecentWeeklyReport recentWeeklyReport;
  final LevelProgress levelProgress;
  final String? stageFocusLearnToRead;
  final String? stageFocusEarlyReader;

  ApiReportResponse({
    required this.weeklyReport,
    required this.totalLearned,
    required this.recentWeeklyReport,
    required this.levelProgress,
    this.stageFocusLearnToRead,
    this.stageFocusEarlyReader,
  });

  ApiReportResponse.fromJson(Map<String, dynamic> json)
    : weeklyReport = TotalReport.fromJson(json['WeeklyReport']),
      totalLearned = TotalReport.fromJson(json['TotalLearned']),
      recentWeeklyReport = RecentWeeklyReport.fromJson(
        json['RecentWeeklyReport'],
      ),
      levelProgress = LevelProgress.fromJson(json['Progress']['Level']),
      stageFocusLearnToRead = json['StageFocusLearnToRead'],
      stageFocusEarlyReader = json['StageFocusEarlyReader'];

  LearningReportEntity toEntity() => LearningReportEntity(
    weeklyReport: weeklyReport.toEntity(),
    totalLearned: totalLearned.toEntity(),
    recentWeeklyReport: recentWeeklyReport.toEntity(),
    levelProgress: levelProgress.toEntity(),
  );
}

class TotalReport {
  final GeneralReport generalReport;
  final Map<String, int> storyByLevel;

  TotalReport({required this.generalReport, required this.storyByLevel});

  TotalReport.fromJson(Map<String, dynamic> json)
    : generalReport = GeneralReport.fromJson(json['General']),
      storyByLevel = Map<String, int>.from(json['Proportion']['Level']);

  TotalReportEntity toEntity() => TotalReportEntity(
    generalReport: generalReport.toEntity(),
    storyByLevel: storyByLevel,
  );
}

class GeneralReport {
  final int totalStory;
  final int totalLesson;
  final int totalVideo;
  final int totalAudioBook;
  final int totalDuration;

  GeneralReport({
    this.totalStory = 0,
    this.totalLesson = 0,
    this.totalVideo = 0,
    this.totalAudioBook = 0,
    this.totalDuration = 0,
  });

  GeneralReport.fromJson(Map<String, dynamic> json)
    : totalStory = json['TotalStory'],
      totalLesson = json['TotalLesson'],
      totalVideo = json['TotalVideo'],
      totalAudioBook = json['AudioBook'],
      totalDuration = json['TotalDuration'];

  GeneralReportEntity toEntity() => GeneralReportEntity(
    totalStory: totalStory,
    totalLesson: totalLesson,
    totalVideo: totalVideo,
    totalAudioBook: totalAudioBook,
    totalDuration: totalDuration,
  );
}

class RecentWeeklyReport {
  final int week1;
  final int week2;
  final int week3;
  final int week4;

  RecentWeeklyReport({
    this.week1 = 0,
    this.week2 = 0,
    this.week3 = 0,
    this.week4 = 0,
  });

  RecentWeeklyReport.fromJson(Map<String, dynamic> json)
    : week1 = json['W1'],
      week2 = json['W2'],
      week3 = json['W3'],
      week4 = json['W4'];

  RecentWeeklyReportEntity toEntity() => RecentWeeklyReportEntity(
    week1: week1,
    week2: week2,
    week3: week3,
    week4: week4,
  );
}

class Progress {
  final int current;
  final int total;

  const Progress({this.current = 0, this.total = 1});

  Progress.fromJson(Map<String, dynamic>? json)
    : current = json?['Current'] ?? 0,
      total = json?['Total'] ?? 0;

  ProgressEntity toEntity() => ProgressEntity(current: current, total: total);
}

class LevelProgress {
  final Progress one;
  final Progress two;
  final Progress three;
  final Progress four;
  final Progress five;
  final Progress six;
  final Progress seven;

  const LevelProgress({
    this.one = const Progress(),
    this.two = const Progress(),
    this.three = const Progress(),
    this.four = const Progress(),
    this.five = const Progress(),
    this.six = const Progress(),
    this.seven = const Progress(),
  });

  LevelProgress.fromJson(Map<String, dynamic> json)
    : one = Progress.fromJson(json[StageId.one.value]),
      two = Progress.fromJson(json[StageId.two.value]),
      three = Progress.fromJson(json[StageId.three.value]),
      four = Progress.fromJson(json[StageId.four.value]),
      five = Progress.fromJson(json[StageId.five.value]),
      six = Progress.fromJson(json[StageId.six.value]),
      seven = Progress.fromJson(json[StageId.seven.value]);

  LevelProgressEntity toEntity() => LevelProgressEntity(
    one: one.toEntity(),
    two: two.toEntity(),
    three: three.toEntity(),
    four: four.toEntity(),
    five: five.toEntity(),
    six: six.toEntity(),
    seven: seven.toEntity(),
  );
}
