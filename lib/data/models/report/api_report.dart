import 'package:monkey_stories/domain/entities/report/report_entity.dart';

class ApiReportResponse {
  final TotalReport weeklyReport;
  final TotalReport totalLearned;
  final RecentWeeklyReport recentWeeklyReport;
  final LevelProgress levelProgress;

  ApiReportResponse({
    required this.weeklyReport,
    required this.totalLearned,
    required this.recentWeeklyReport,
    required this.levelProgress,
  });

  ApiReportResponse.fromJson(Map<String, dynamic> json)
    : weeklyReport = TotalReport.fromJson(json['WeeklyReport']),
      totalLearned = TotalReport.fromJson(json['TotalLearned']),
      recentWeeklyReport = RecentWeeklyReport.fromJson(
        json['RecentWeeklyReport'],
      ),
      levelProgress = LevelProgress.fromJson(json['Progress']['Level']);

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

  Progress.fromJson(Map<String, dynamic> json)
    : current = json['Current'],
      total = json['Total'];

  ProgressEntity toEntity() => ProgressEntity(current: current, total: total);
}

class LevelProgress {
  final Progress nursery;
  final Progress kindergarten;
  final Progress grade1;

  const LevelProgress({
    this.nursery = const Progress(),
    this.kindergarten = const Progress(),
    this.grade1 = const Progress(),
  });

  LevelProgress.fromJson(Map<String, dynamic> json)
    : nursery = Progress.fromJson(json['Nursery']),
      kindergarten = Progress.fromJson(json['Kindergarten']),
      grade1 = Progress.fromJson(json['Grade1']);

  LevelProgressEntity toEntity() => LevelProgressEntity(
    nursery: nursery.toEntity(),
    kindergarten: kindergarten.toEntity(),
    grade1: grade1.toEntity(),
  );
}
