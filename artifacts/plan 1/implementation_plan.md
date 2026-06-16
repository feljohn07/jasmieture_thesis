# Goal Description

The goal is to ensure that game history, total stars, and shop customizations (purchased characters, items, backgrounds, and currently equipped items) are stored and retrieved separately for each user (player), rather than globally. 

## User Review Required

> [!WARNING]
> We will be adding new fields to the `Shop` model to track purchased items per player, and updating `ShopRepository` to store a unique `Shop` instance per player using the `player.key`. This requires regenerating the Hive adapters for `Shop`. Any existing shop data will be reset since the schema and access pattern are changing.

## Open Questions
None. (Proceeding based on your feedback: customizations should also be per player, and I will manually update the `.g.dart` files to save time).

## Proposed Changes

### Hive Models & Adapters
#### [MODIFY] [shop.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/models/shop/shop.dart)
- Add `@HiveField(6) List<String> purchasedCharacters;`
- Add `@HiveField(7) List<String> purchasedItems;`
- Add `@HiveField(8) List<String> purchasedBackgrounds;`
- Initialize these lists in the constructor.

#### [MODIFY] [shop.g.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/models/shop/shop.g.dart)
- Manually update the adapter to include the new fields.

### Repositories
#### [MODIFY] [shop_repository.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/repositories/shop_repository.dart)
- Update methods `getShop`, `setStar`, `purchaseItem`, `purchaseBackground`, `purchaseCharacter` to accept an `int playerKey` parameter.

#### [MODIFY] [shop_repository_impl.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/repositories/implementations/shop_repository_impl.dart)
- `getShop(int playerKey)`: Use `_shopBox.get(playerKey)` to retrieve the specific player's shop. If it doesn't exist, create it using `_shopBox.put(playerKey, Shop(...))` with default empty purchase lists.
- Update purchase methods to add the item's ID/name to the respective `purchased...` list in the `Shop` object, instead of setting `item.purchased = true` globally.

### View Models
#### [MODIFY] [shop_data.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/view_models.dart/shop_data.dart)
- Update `ShopData` to accept an `AuthProvider` so it knows the active player.
- Make it listen to `AuthProvider` (or update dynamically) to reload `shop` when the active player changes.
- Override the `purchased` getter for characters, items, and backgrounds within `ShopData` to check the current player's `Shop` lists instead of the global `purchased` flag on the models.

#### [MODIFY] [quiz_data.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/view_models.dart/quiz_data.dart)
- (No changes needed here if `game_history_screen` uses `historiesForPlayer` directly).

### UI Screens
#### [MODIFY] [game_history_screen.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/screens/game_history_screen.dart)
- Fetch histories using `context.watch<QuizData>().historiesForPlayer(player.key)`.

#### [MODIFY] [main.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/main.dart)
- Use `ChangeNotifierProxyProvider<AuthProvider, ShopData>` to inject the `AuthProvider` into `ShopData` so it automatically reloads the correct shop when a user logs in or out.

## Verification Plan

### Manual Verification
1. Log in as Player A. Buy a character and an item. The stars should decrease, and the items should show as equipped/purchased.
2. Log out and log in as Player B. Player B should have 0 stars, default equipped items, and no purchases.
3. Check Game History for both players to confirm they are isolated.
