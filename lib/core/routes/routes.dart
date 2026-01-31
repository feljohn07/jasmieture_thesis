// import 'package:jasmieture_thesis/models/game/history.dart';
import 'package:jasmieture_thesis/models/player_data.dart';
import 'package:jasmieture_thesis/screens/chapters.dart';
import 'package:jasmieture_thesis/screens/create_player_screen.dart';
import 'package:jasmieture_thesis/screens/game_history_screen.dart';
import 'package:jasmieture_thesis/screens/levels.dart';
import 'package:jasmieture_thesis/screens/main_menu_screen.dart';
import 'package:jasmieture_thesis/screens/profile_screen.dart';
import 'package:jasmieture_thesis/screens/settings_screen.dart';
import 'package:jasmieture_thesis/screens/game_screen.dart';
import 'package:jasmieture_thesis/screens/shop/shop.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final routes = GoRouter(
  // initialLocation: CreateProfileScreen.path,
  initialLocation: '/',
  redirect: (context, state) async {
    final player = context.read<PlayerData>().playerRepository.getPlayer();
    // final hasAccess = context.read<AccessControl>().accessState;
    //
    // print(hasAccess);

    if (player == null) {
      return CreateProfileScreen.path;
    }

    return null;
  },
  routes: [

    GoRoute(
      path: MainMenuScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: MainMenuScreen());
      },
    ),
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: GameHistoryScreen());
      },
    ),
    GoRoute(
      path: '/levels',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: LevelScreen());
      },
    ),
    GoRoute(
      path: '/chapters',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ChaptersScreen(level: state.extra as int));
      },
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: GameScreen());
      },
    ),
    GoRoute(
      path: '/shop',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ShopScreen());
      },
    ),
    GoRoute(
      path: '/profile',
      // builder: (context, state) {
      //   return  ProfileScreen();
      // },
      pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: SettingsScreen());
      },
    ),
    GoRoute(
      path: CreateProfileScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: CreateProfileScreen());
      },
    ),
    GoRoute(
      path: ProfileScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ProfileScreen());
      },
    ),
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) {
    //     return ShopScreen();
    //   },
    // ),
  ],
);
