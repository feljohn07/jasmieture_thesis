# Summary of Changes

I've updated the architecture so that your application correctly handles **Stars, Game History, and Shop Customizations** on a **per-player** basis!

## 1. Shop Customizations & Stars
- **Updated `Shop` Model:** I modified the `Shop` Hive model to keep track of lists for `purchasedCharacters`, `purchasedItems`, and `purchasedBackgrounds`. 
- **Generated Adapters:** I ran `build_runner` to regenerate `shop.g.dart` to support the new lists inside the Hive box.
- **Updated `ShopRepository`:** Modified the repository methods (`getShop`, `setStar`, `purchaseItem`, etc.) to accept a `playerKey`. The repository now creates and fetches a unique `Shop` instance for each player.
- **Dynamic `ShopData`:** The `ShopData` view model was refactored to depend on `AuthProvider`. It now automatically fetches the active player's shop upon login and determines item `purchased` state on the fly based on the player's purchase history. If no player is logged in, it gracefully uses a default sandbox (key: `-1`).

## 2. Game History
- **Updated `game_history_screen.dart`:** The screen now watches the `AuthProvider` to get the current player, and then queries the `QuizData` specifically using `historiesForPlayer(player.key)` to fetch only their historical game records.

## What was tested
- Hive Schema (`player.g.dart`) builds properly via Build Runner.
- Dependency injection via Provider cleanly supports linking the authentication state to the shop state.

> [!TIP]
> Now, whenever a new player logs into the app, their customized characters, backgrounds, shop items, stars, and history will all load uniquely, providing a robust multi-user offline profile experience!
