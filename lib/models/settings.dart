import 'package:jasmieture_thesis/game/audio_manager.dart';
import 'package:jasmieture_thesis/models/bgm.dart';
import 'package:jasmieture_thesis/models/game/settings.dart';
import 'package:jasmieture_thesis/repositories/audio_repository.dart';
import 'package:jasmieture_thesis/repositories/settings_repository.dart';
import 'package:flutter/foundation.dart';

class SettingsData extends ChangeNotifier {
  SettingsRepository settingsRepository;
  late Settings settings;

  SettingsData(this.settingsRepository) {
    settings = settingsRepository.getSettings();
  }

  AudioBgm get bgmPath => settings.bgmPath;
  Future<void> setBgmPath(AudioBgm path) async {
    await settingsRepository.setBgmPath(path);
    AudioManager.instance.startBgm(path);

    notifyListeners();
  }

  bool get bgm => settings.bgm;
  Future<void> setBgm(bool value) async {
    await settingsRepository.setBgm(value);
    settings = settingsRepository.getSettings();
    notifyListeners();
  }

  bool get sfx => settings.sfx;
  Future<void> setSfx(bool value) async {
    await settingsRepository.setSfx(value);
    settings = settingsRepository.getSettings();
    notifyListeners();
  }
}
