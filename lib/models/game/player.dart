import 'package:jasmieture_thesis/models/bgm.dart';
import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class Player extends HiveObject {
  // ── Identity ────────────────────────────────────────────────────────────────
  @HiveField(0)
  String firstname;
  @HiveField(1)
  String lastname;
  @HiveField(2)
  String middlename;
  @HiveField(3)
  String section;
  @HiveField(4)
  int age;

  // ── Auth ────────────────────────────────────────────────────────────────────
  /// Plain-text 4-digit PIN (prototype only — no hashing).
  @HiveField(5)
  String pin;

  // ── Per-player Settings ─────────────────────────────────────────────────────
  @HiveField(6)
  bool bgm;
  @HiveField(7)
  bool sfx;
  @HiveField(8)
  double volume;
  @HiveField(9)
  String language;
  /// Stored as enum index to avoid string parsing.
  @HiveField(10)
  int bgmPathIndex;

  // ── Per-player Progress ─────────────────────────────────────────────────────
  /// Level numbers (e.g. [1, 2]) that this player has unlocked.
  @HiveField(11)
  List<int> unlockedLevels;

  /// Encoded as "level:chapter" strings (e.g. ["1:1", "1:2"]).
  @HiveField(12)
  List<String> unlockedChapters;

  Player({
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.section,
    required this.age,
    required this.pin,
    this.bgm = true,
    this.sfx = true,
    this.volume = 1.0,
    this.language = 'english',
    this.bgmPathIndex = 4, // AudioBgm.mineCraft03
    List<int>? unlockedLevels,
    List<String>? unlockedChapters,
  })  : unlockedLevels = unlockedLevels ?? [1],
        unlockedChapters = unlockedChapters ?? ['1:1'];

  /// Convenience getter for the AudioBgm enum value.
  AudioBgm get bgmPath => AudioBgm.values[bgmPathIndex.clamp(0, AudioBgm.values.length - 1)];

  /// Returns true if this player has unlocked the given level number.
  bool isLevelUnlocked(int levelNum) => unlockedLevels.contains(levelNum);

  /// Returns true if this player has unlocked a specific chapter.
  bool isChapterUnlocked(int levelNum, int chapterNum) =>
      unlockedChapters.contains('$levelNum:$chapterNum');

  /// Unlock a level and save.
  Future<void> unlockLevel(int levelNum) async {
    if (!unlockedLevels.contains(levelNum)) {
      unlockedLevels.add(levelNum);
      await save();
    }
  }

  /// Unlock a chapter and save.
  Future<void> unlockChapter(int levelNum, int chapterNum) async {
    final key = '$levelNum:$chapterNum';
    if (!unlockedChapters.contains(key)) {
      unlockedChapters.add(key);
      await save();
    }
  }
}
