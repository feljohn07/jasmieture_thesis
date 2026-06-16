# Execution Plan

- `[x]` Update `Shop` model (`lib/models/shop/shop.dart`) to add `purchasedCharacters`, `purchasedItems`, `purchasedBackgrounds`.
- `[x]` Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate `.g.dart` files.
- `[x]` Update `ShopRepository` and `ShopRepositoryImpl` to scope shop retrieval and purchases by `playerKey`.
- `[x]` Refactor `ShopData` to depend on `AuthProvider` and read the shop for the currently logged-in player, including correctly reporting purchased items.
- `[x]` Update `game_history_screen.dart` to use `historiesForPlayer(currentPlayer.key)`.
- `[x]` Update `main.dart` to inject `AuthProvider` into `ShopData`.
- `[x]` Verify functionality and create walkthrough.
