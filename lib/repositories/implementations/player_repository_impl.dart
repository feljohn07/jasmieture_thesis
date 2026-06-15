// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:jasmieture_thesis/models/game/player.dart';
import 'package:jasmieture_thesis/repositories/data/datasource.dart';
import 'package:jasmieture_thesis/repositories/player_repository.dart';

class PlayerRepositoryImp extends PlayerRepository {
  final Datasource datasource;

  PlayerRepositoryImp({required this.datasource});

  Box<Player> get _box => datasource.playerBox;

  @override
  Future<void> createPlayer(Player player) async {
    await _box.add(player);
  }

  @override
  Future<void> updatePlayer(Player player) async {
    await player.save();
  }

  @override
  Future<void> deletePlayer(Player player) async {
    await player.delete();
  }

  /// Returns the single stored player (legacy single-player compat).
  @override
  Player? getPlayer() {
    return _box.values.firstOrNull;
  }

  @override
  List<Player> getAllPlayers() {
    return _box.values.toList();
  }

  @override
  Player? getPlayerByKey(int key) {
    return _box.get(key);
  }
}
