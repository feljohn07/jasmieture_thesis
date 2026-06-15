import 'package:jasmieture_thesis/screens/chapters.dart';
import 'package:jasmieture_thesis/screens/create_player_screen.dart';
import 'package:jasmieture_thesis/screens/game_history_screen.dart';
import 'package:jasmieture_thesis/screens/levels.dart';
import 'package:jasmieture_thesis/screens/login_screen.dart';
import 'package:jasmieture_thesis/screens/main_menu_screen.dart';
import 'package:jasmieture_thesis/screens/profile_screen.dart';
import 'package:jasmieture_thesis/screens/settings_screen.dart';
import 'package:jasmieture_thesis/screens/game_screen.dart';
import 'package:jasmieture_thesis/screens/shop/shop.dart';
import 'package:jasmieture_thesis/view_models.dart/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final routes = GoRouter(
  initialLocation: LoginScreen.path,
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final isOnAuthRoutes = state.fullPath == LoginScreen.path ||
        state.fullPath == CreateProfileScreen.path;

    // Not logged in → always go to login
    if (!auth.isLoggedIn && !isOnAuthRoutes) {
      return LoginScreen.path;
    }

    // Already logged in → skip the login page if trying to access it
    if (auth.isLoggedIn && state.fullPath == LoginScreen.path) {
      return MainMenuScreen.path;
    }

    return null;
  },
  routes: [
    // ── Auth routes ──────────────────────────────────────────────────────────
    GoRoute(
      path: LoginScreen.path,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      path: CreateProfileScreen.path,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: CreateProfileScreen()),
    ),

    // ── App routes (require login) ───────────────────────────────────────────
    GoRoute(
      path: MainMenuScreen.path,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: MainMenuScreen()),
    ),
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: GameHistoryScreen()),
    ),
    GoRoute(
      path: '/levels',
      pageBuilder: (context, state) => NoTransitionPage(child: LevelScreen()),
    ),
    GoRoute(
      path: '/chapters',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: ChaptersScreen(level: state.extra as int)),
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) => NoTransitionPage(child: GameScreen()),
    ),
    GoRoute(
      path: '/shop',
      pageBuilder: (context, state) => NoTransitionPage(child: ShopScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: SettingsScreen()),
    ),
    GoRoute(
      path: ProfileScreen.path,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: ProfileScreen()),
    ),
  ],
);
