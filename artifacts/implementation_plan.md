# Multiplayer / Multi-User Support

## Background

The app currently supports only a **single, unnamed player** stored in a Hive box (`player`). The router checks `playerBox.values.firstOrNull` — if it is `null`, it redirects to `CreateProfileScreen`; otherwise it goes straight to the main menu. There is no concept of accounts, authentication, login, or logout.

The goal is to allow **multiple users** to register, each with their own profile and per-player game progress (quiz history, unlocked levels/chapters, shop items). Users can log out and log back in to view their personal progress.

---

## User Review Required

> [!IMPORTANT]
> **Local-only vs. cloud accounts?**
> The simplest approach is **100% local** — all accounts live on the device in Hive (no server, no passwords, no internet). This is the recommended path given the existing stack.
> If you want cloud accounts (Firebase Auth / Supabase), the scope is significantly larger and requires additional back-end setup.
> **Please confirm which approach you prefer before implementation begins.**

> [!WARNING]
> **Password / PIN security**: For a local-only system the "password" would be stored as a hashed string inside Hive. There is no key recovery — a forgotten PIN would lock a user out of their profile permanently unless we add a reset mechanism.

> [!NOTE]
> **History & unlocks are currently global** — they belong to the one Hive box, not to an individual player. We must move them to be **per-player** scoped. This is a data-model breaking change and requires regenerating Hive adapters.

---

## Open Questions

1. **Authentication method** — simple name-based picker (select your profile from a list), or username + password/PIN?
2. **Can users delete their own profiles?** Or is that admin-only?
3. **Should game progress (unlocked levels/chapters) also be per-player?** Currently unlock state lives on the `Level`/`Chapter` Hive objects globally. Scoping that per-player is the cleanest but requires more work.
4. **Settings (BGM/SFX/language)** — should these be per-player or global device settings? Currently they are global.

---

## Proposed Changes

This plan assumes: **Local-only accounts, username + PIN authentication, per-player history, per-player shop, per-player game progress, global device settings.**

---

### 1. Data Models

#### [MODIFY] [player.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/models/game/player.dart)
Add new Hive fields to `Player`:
- `@HiveField(5) String username` — unique login handle
- `@HiveField(6) String pin` — bcrypt/sha-256 hashed 4-digit PIN (or plain for simplicity)
- `@HiveField(7) bool isLoggedIn` — convenience flag to identify the active session
- `@HiveField(8) List<History> histories` — embed per-player history (or keep in a separate box with a `playerId` key)

Re-run `build_runner` to regenerate `player.g.dart`.

#### [MODIFY] [history.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/models/game/history.dart)
Add `@HiveField(4) String playerId` so history records can be filtered per player when kept in the shared history box.

---

### 2. Auth State Management

#### [NEW] `lib/view_models.dart/auth_provider.dart`
A new `ChangeNotifier` that wraps the active session:

```dart
class AuthProvider extends ChangeNotifier {
  Player? _currentPlayer;
  Player? get currentPlayer => _currentPlayer;
  bool get isLoggedIn => _currentPlayer != null;

  Future<void> login(Player player) { ... }
  Future<void> logout() { ... }
  Future<bool> validatePin(Player player, String pin) { ... }
}
```

---

### 3. Repository Layer

#### [MODIFY] [player_repository.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/repositories/player_repository.dart)
Extend the interface:
```dart
List<Player> getAllPlayers();
Player? getPlayerByUsername(String username);
Future<void> deletePlayer(Player player);
```

#### [MODIFY] [player_repository_impl.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/repositories/implementations/player_repository_impl.dart)
Implement the new methods. `getPlayer()` is renamed/repurposed to `getActivePlayer()` (returns the logged-in player).

#### [MODIFY] [game_history_repository_impl.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/repositories/implementations/game_history_repository_impl.dart)
Add a `allForPlayer(String playerId)` method to filter history by player.

---

### 4. Datasource

#### [MODIFY] [datasource.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/repositories/data/datasource.dart)
- Remove the `.clear()` calls on `_playerBox` (currently all boxes are cleared on every app launch, which is a testing artefact — **must** be fixed before multi-user can work at all).
- Keep player data persistent across app restarts.

---

### 5. Screens

#### [NEW] `lib/screens/login_screen.dart`
Shown when no player is logged in. Displays:
- A list of registered profiles (avatar + name) as selectable cards.
- A "New Profile" button → navigates to `CreateProfileScreen`.
- Tapping a profile → prompts for PIN → logs in → goes to Main Menu.

#### [NEW] `lib/screens/register_screen.dart`  *(or extend existing `CreateProfileScreen`)*
Adds `username` and `pin` (+ confirm PIN) fields to the existing multi-page create-profile flow.

#### [MODIFY] [create_player_screen.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/screens/create_player_screen.dart)
Add page step(s) for `username` and PIN setup after the existing name/age/section steps.

#### [MODIFY] [profile_screen.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/screens/profile_screen.dart)
- Reads from `AuthProvider.currentPlayer` instead of `PlayerData.playerRepository.getPlayer()`.
- Adds a **"Logout"** button that calls `AuthProvider.logout()` and routes to `LoginScreen`.
- History tab/section shows only the current player's records.

#### [MODIFY] [main_menu_screen.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/screens/main_menu_screen.dart)
Show current player's name/avatar in the corner. No other structural changes needed.

---

### 6. Routing

#### [MODIFY] [routes.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/core/routes/routes.dart)
Update the `redirect` guard:
```dart
redirect: (context, state) {
  final auth = context.read<AuthProvider>();
  if (!auth.isLoggedIn) return LoginScreen.path;
  return null;
}
```
Add a route for `LoginScreen`.

---

### 7. Dependency Injection

#### [MODIFY] [main.dart](file:///c:/Users/user/Desktop/Coding%20Projects/jasmieture_thesis/lib/main.dart)
Add `AuthProvider` to the `MultiProvider` list. Update `QuizData`, `ShopData`, `RiveProvider` to be re-initialized (or scoped) when a user logs in/out — the cleanest approach is to create a nested `MultiProvider` inside the app that is rebuilt when the auth state changes.

---

## Implementation Sequence

```mermaid
graph TD
    A[1. Fix datasource - remove clear() calls] --> B[2. Extend Player model + history with playerId]
    B --> C[3. Regenerate Hive adapters via build_runner]
    C --> D[4. Extend repository interfaces & impls]
    D --> E[5. Create AuthProvider]
    E --> F[6. Create LoginScreen UI]
    F --> G[7. Extend CreateProfileScreen with username+PIN]
    G --> H[8. Update routes.dart guard]
    H --> I[9. Add logout to ProfileScreen]
    I --> J[10. Scope history & progress per player]
    J --> K[11. Update main.dart providers]
```

---

## Verification Plan

### Automated Tests
- None currently exist; out of scope for this sprint.

### Manual Verification
1. Fresh install → lands on **Login Screen** (no profiles).
2. Tap "New Profile" → complete all steps including username + PIN → arrives at Main Menu.
3. Play a quiz, complete a chapter → check history is visible on Profile Screen.
4. Tap "Logout" on Profile Screen → returns to Login Screen.
5. Log in as the same user with the correct PIN → history/progress is preserved.
6. Register a **second** user → separate history, separate progress.
7. Switch between users — each sees their own data only.
8. Kill and reopen app → Login Screen appears; existing profiles are still listed.
