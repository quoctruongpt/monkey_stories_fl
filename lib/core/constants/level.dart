class LevelId {
  static const int a = 4;
  static const int b = 5;
  static const int e = 8;
  static const int j = 13;
}

class Phase {
  final String name;
  final String description;

  Phase({required this.name, required this.description});
}

List<Phase> phase = [
  Phase(
    name: 'app.suggest_level.level1',
    description: 'app.suggest_level.level1.desc',
  ),
  Phase(
    name: 'app.suggest_level.level2',
    description: 'app.suggest_level.level2.desc',
  ),
  Phase(
    name: 'app.suggest_level.level3',
    description: 'app.suggest_level.level3.desc',
  ),
  Phase(name: 'app.suggest_level.level4', description: ''),
];

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
    name: 'A',
    id: LevelId.a,
    description: 'create_profile.level.a',
    difficulty: 0,
  ),
  LevelOnboarding(
    name: 'B',
    id: LevelId.b,
    description: 'create_profile.level.b',
    difficulty: 1,
  ),
  LevelOnboarding(
    name: 'E',
    id: LevelId.e,
    description: 'create_profile.level.c',
    difficulty: 2,
  ),
  LevelOnboarding(
    name: 'J',
    id: LevelId.j,
    description: 'create_profile.level.d',
    difficulty: 3,
  ),
];
