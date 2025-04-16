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
    description: 'create_profile.level.a',
    difficulty: 0,
  ),
  LevelOnboarding(
    name: "B",
    id: 2,
    description: 'create_profile.level.b',
    difficulty: 1,
  ),
  LevelOnboarding(
    name: "C",
    id: 3,
    description: 'create_profile.level.c',
    difficulty: 2,
  ),
  LevelOnboarding(
    name: "D",
    id: 4,
    description: 'create_profile.level.d',
    difficulty: 3,
  ),
];
