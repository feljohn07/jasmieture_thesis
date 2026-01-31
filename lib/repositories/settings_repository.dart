import 'package:jasmieture_thesis/models/bgm.dart';
import 'package:jasmieture_thesis/models/game/settings.dart';
import 'package:jasmieture_thesis/repositories/audio_repository.dart';

abstract class SettingsRepository {
  // Future<void> initialize();
  Settings getSettings();
  Future<void> setBgm(bool enable);
  Future<void> setSfx(bool enable);
  Future<void> setBgmVolumne(double volume);
  Future<void> setLanguage(String language);

  Future<void> setBgmPath(AudioBgm path);
}
