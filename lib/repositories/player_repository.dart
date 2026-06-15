import 'package:jasmieture_thesis/models/game/player.dart';

abstract class PlayerRepository {
  Player? getPlayer();
  List<Player> getAllPlayers();
  Player? getPlayerByKey(int key);
  Future<void> createPlayer(Player player);
  Future<void> updatePlayer(Player player);
  Future<void> deletePlayer(Player player);
}
