import 'package:jasmieture_thesis/models/shop/background.dart';
import 'package:jasmieture_thesis/models/shop/character.dart';
import 'package:jasmieture_thesis/models/shop/item.dart';
import 'package:jasmieture_thesis/models/shop/shop.dart';

abstract class ShopRepository {
  // Future<void> init();

  Shop getShop(int playerKey);
  Future<void> setStar(int playerKey, int star);

  List<Character> getCharacters();

  List<Item> getItems();
  List<Background> getBackgrounds();

  Future<void> purchaseItem(int playerKey, Item item);
  Future<void> purchaseBackground(int playerKey, Background background);
  Future<void> purchaseCharacter(int playerKey, Character character);
}
