import 'package:jasmieture_thesis/models/game/history.dart';

abstract class GameHistoryRepository {
  Future<void> add(History history);
  List<History> all();
  List<History> allForPlayer(int playerKey);
}
