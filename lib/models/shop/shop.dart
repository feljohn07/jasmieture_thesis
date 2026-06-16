// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:jasmieture_thesis/models/shop/background.dart';
import 'package:jasmieture_thesis/models/shop/character.dart';
import 'package:jasmieture_thesis/models/shop/item.dart';

part 'shop.g.dart';

@HiveType(typeId: 9)
class Shop extends HiveObject {
  @HiveField(0)
  int star;
  @HiveField(1)
  Character characterSelected;
  @HiveField(2)
  Item headItemSelected;
  @HiveField(3)
  Item eyeItemSelected;
  @HiveField(4)
  Item shirtItemSelected;
  @HiveField(5)
  Background backgroundSelected;

  @HiveField(6)
  List<String> purchasedCharacters;
  @HiveField(7)
  List<String> purchasedItems;
  @HiveField(8)
  List<String> purchasedBackgrounds;

  Shop({
    required this.star,
    required this.characterSelected,
    required this.headItemSelected,
    required this.eyeItemSelected,
    required this.shirtItemSelected,
    required this.backgroundSelected,
    List<String>? purchasedCharacters,
    List<String>? purchasedItems,
    List<String>? purchasedBackgrounds,
  })  : purchasedCharacters = purchasedCharacters ?? [],
        purchasedItems = purchasedItems ?? [],
        purchasedBackgrounds = purchasedBackgrounds ?? [];

  @override
  String toString() {
    return 'Shop(star: $star, characterSelected: $characterSelected, headItemSelected: $headItemSelected, eyeItemSelected: $eyeItemSelected, shirtItemSelected: $shirtItemSelected, backgroundSelected: $backgroundSelected, purchasedCharacters: $purchasedCharacters, purchasedItems: $purchasedItems, purchasedBackgrounds: $purchasedBackgrounds)';
  }
}
