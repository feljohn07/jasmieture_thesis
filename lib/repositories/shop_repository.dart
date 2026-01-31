import 'package:jasmieture_thesis/models/shop/background.dart';
import 'package:jasmieture_thesis/models/shop/character.dart';
import 'package:jasmieture_thesis/models/shop/item.dart';
import 'package:jasmieture_thesis/models/shop/shop.dart';

abstract class ShopRepository {
  // Future<void> init();

  Shop getShop();
  Future<void> setStar(int star);

  List<Character> getCharacters();

  List<Item> getItems();
  List<Background> getBackgrounds();

  Future<void> purchaseItem(Item item);
  Future<void> purchaseBackground(Background background);
  Future<void> purchaseCharacter(Character character);
}
