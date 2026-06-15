import 'package:flutter/foundation.dart';
import 'package:jasmieture_thesis/models/game/player.dart';
import 'package:jasmieture_thesis/models/settings.dart';
import 'package:jasmieture_thesis/repositories/player_repository.dart';
import 'package:jasmieture_thesis/repositories/settings_repository.dart';
import 'package:jasmieture_thesis/game/audio_manager.dart';

/// Manages the active user session.
///
/// Call [login] to authenticate a player and [logout] to end the session.
/// All other providers (QuizData, ShopData, etc.) should read the active
/// player from [currentPlayer] rather than the repository directly.
class AuthProvider extends ChangeNotifier {
  final PlayerRepository playerRepository;
  final SettingsRepository settingsRepository;
  final SettingsData settingsData;

  AuthProvider({
    required this.playerRepository,
    required this.settingsRepository,
    required this.settingsData,
  });

  Player? _currentPlayer;

  /// The player that is currently logged in, or null if no session is active.
  Player? get currentPlayer => _currentPlayer;

  bool get isLoggedIn => _currentPlayer != null;

  // ── Authentication ──────────────────────────────────────────────────────────

  /// Returns true and starts the session if [pin] matches the player's stored PIN.
  Future<bool> login(Player player, String pin) async {
    if (player.pin != pin) return false;
    _currentPlayer = player;
    await _applyPlayerSettings(player);
    notifyListeners();
    return true;
  }

  /// Saves current settings back to the player, then clears the session.
  Future<void> logout() async {
    if (_currentPlayer != null) {
      await _saveSettingsToPlayer(_currentPlayer!);
    }
    _currentPlayer = null;
    notifyListeners();
  }

  /// Validates that [pin] matches the given [player] without starting a session.
  bool validatePin(Player player, String pin) => player.pin == pin;

  // ── Progress helpers ────────────────────────────────────────────────────────

  /// Unlocks [levelNum] for the active player and persists.
  Future<void> unlockLevel(int levelNum) async {
    await _currentPlayer?.unlockLevel(levelNum);
    notifyListeners();
  }

  /// Unlocks a chapter for the active player and persists.
  Future<void> unlockChapter(int levelNum, int chapterNum) async {
    await _currentPlayer?.unlockChapter(levelNum, chapterNum);
    notifyListeners();
  }

  bool isLevelUnlocked(int levelNum) =>
      _currentPlayer?.isLevelUnlocked(levelNum) ?? (levelNum == 1);

  bool isChapterUnlocked(int levelNum, int chapterNum) =>
      _currentPlayer?.isChapterUnlocked(levelNum, chapterNum) ??
      (levelNum == 1 && chapterNum == 1);

  // ── Settings helpers ────────────────────────────────────────────────────────

  /// Applies a player's saved settings to the global [SettingsData] provider
  /// and the [AudioManager].
  Future<void> _applyPlayerSettings(Player player) async {
    // Update the Hive Settings object to reflect this player's preferences.
    final settings = settingsRepository.getSettings();
    settings
      ..bgm = player.bgm
      ..sfx = player.sfx
      ..volume = player.volume
      ..language = player.language
      ..bgmPath = player.bgmPath;
    await settings.save();

    // Notify SettingsData so dependent UI widgets rebuild.
    settingsData.reloadFromRepository();

    // Apply audio settings immediately.
    if (player.bgm) {
      AudioManager.instance.startBgm(player.bgmPath);
    } else {
      AudioManager.instance.pauseBgm();
    }
  }

  /// Copies current Hive settings back into the player object and saves.
  Future<void> _saveSettingsToPlayer(Player player) async {
    final settings = settingsRepository.getSettings();
    player
      ..bgm = settings.bgm
      ..sfx = settings.sfx
      ..volume = settings.volume
      ..language = settings.language
      ..bgmPathIndex = settings.bgmPath.index;
    await player.save();
  }
}
