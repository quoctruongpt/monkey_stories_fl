class Level {
  final String name;
  final int id;

  Level({required this.name, required this.id});
}

class LevelOnboarding extends Level {
  final String description;
  final int difficulty;

  LevelOnboarding({
    required super.name,
    required super.id,
    required this.description,
    required this.difficulty,
  });
}

final List<LevelOnboarding> onboardingLevels = [
  LevelOnboarding(
    name: "A",
    id: 1,
    description: "Bé chưa biết gì về tiếng Anh",
    difficulty: 0,
  ),
  LevelOnboarding(
    name: "B",
    id: 2,
    description: "Bé nhận biết được vài từ đơn giản",
    difficulty: 1,
  ),
  LevelOnboarding(
    name: "C",
    id: 3,
    description: "Bé hiểu được câu ngắn, đơn giản",
    difficulty: 2,
  ),
  LevelOnboarding(
    name: "D",
    id: 4,
    description: "Bé đọc hiểu đoạn văn ngắn",
    difficulty: 3,
  ),
];
