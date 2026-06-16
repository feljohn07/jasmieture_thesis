import 'package:jasmieture_thesis/models/shop/background.dart';
import 'package:jasmieture_thesis/models/shop/character.dart';
import 'package:jasmieture_thesis/models/shop/item.dart';
import 'package:jasmieture_thesis/models/shop/shop.dart';
import 'package:jasmieture_thesis/repositories/data/datasource.dart';
import 'package:jasmieture_thesis/repositories/data/item_data.dart';
import 'package:jasmieture_thesis/repositories/shop_repository.dart';
import 'package:hive/hive.dart';

class ShopRepositoryImpl implements ShopRepository {
  final Datasource datasource;

  ShopRepositoryImpl({required this.datasource});

  Box<Character> get _characterBox => datasource.characterBox;
  Box<Item> get _itemBox => datasource.itemBox;
  Box<Background> get _backgroundBox => datasource.backgroundBox;
  Box<Shop> get _shopBox => datasource.shopBox;

  // late Box<Character> _characterBox;
  // late Box<Item> _itemBox;
  // late Box<Background> _backgroundBox;
  // late Box<Shop> _shopBox;

  // @override
  // Future<void> init() async {
  //   if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(CharacterAdapter());
  //   if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(ItemAdapter());
  //   if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(BackgroundAdapter());
  //   if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(ShopAdapter());

  //   _characterBox = await Hive.openBox<Character>('character');
  //   _itemBox = await Hive.openBox<Item>('item');
  //   _backgroundBox = await Hive.openBox<Background>('background');
  //   _shopBox = await Hive.openBox<Shop>('shop');

  //   await _shopBox.clear();
  //   await _characterBox.clear();
  //   await _itemBox.clear();
  //   await _backgroundBox.clear();

  //   if (_characterBox.isEmpty) {
  //     await _characterBox.addAll(characterData);
  //   }
  //   if (_itemBox.isEmpty) {
  //     await _itemBox.addAll([...headItemData, ...eyeItemData, ...shirtItemData]);
  //   }

  //   if (_backgroundBox.isEmpty) {
  //     _backgroundBox.addAll(backgroundData);
  //   }
  // }

  @override
  List<Character> getCharacters() {
    return _characterBox.values.toList();
  }

  @override
  List<Item> getItems() {
    return _itemBox.values.toList();
  }

  @override
  List<Background> getBackgrounds() {
    return _backgroundBox.values.toList();
  }

  @override
  Future<void> purchaseItem(int playerKey, Item item) async {
    final shop = getShop(playerKey);
    if (!shop.purchasedItems.contains(item.name)) {
      shop.purchasedItems.add(item.name);
    }
    shop.star -= item.cost;
    await shop.save();
  }

  @override
  Future<void> purchaseBackground(int playerKey, Background background) async {
    final shop = getShop(playerKey);
    if (!shop.purchasedBackgrounds.contains(background.name)) {
      shop.purchasedBackgrounds.add(background.name);
    }
    shop.star -= background.cost;
    await shop.save();
  }

  @override
  Shop getShop(int playerKey) {
    if (!_shopBox.containsKey(playerKey)) {
      _shopBox.put(
        playerKey,
        Shop(
          star: 0,
          characterSelected: _characterBox.values.first,
          headItemSelected:
              getItems().where((element) => element.riveInputCategory == RiveItemCategory.headChoices.name).first,
          eyeItemSelected:
              getItems().where((element) => element.riveInputCategory == RiveItemCategory.eyeChoices.name).first,
          shirtItemSelected:
              getItems().where((element) => element.riveInputCategory == RiveItemCategory.shirtPrintChoices.name).first,
          backgroundSelected: getBackgrounds().first,
        ),
      );
    }

    return _shopBox.get(playerKey)!;
  }

  @override
  Future<void> setStar(int playerKey, int star) async {
    final shop = getShop(playerKey);
    shop.star = star;
    await shop.save();
  }

  @override
  Future<void> purchaseCharacter(int playerKey, Character character) async {
    final shop = getShop(playerKey);
    if (!shop.purchasedCharacters.contains(character.name)) {
      shop.purchasedCharacters.add(character.name);
    }
    shop.star -= character.cost;
    await shop.save();
  }
}
