import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

import 'package:jasmieture_thesis/core/shared/colors.dart';
import 'package:jasmieture_thesis/game/audio_manager.dart';
import 'package:jasmieture_thesis/models/game/player.dart';
import 'package:jasmieture_thesis/repositories/audio_repository.dart';
import 'package:jasmieture_thesis/screens/create_player_screen.dart';
import 'package:jasmieture_thesis/screens/main_menu_screen.dart';
import 'package:jasmieture_thesis/view_models.dart/auth_provider.dart';
import 'package:jasmieture_thesis/repositories/player_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const path = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _setOrientation();
  }

  Future<void> _setOrientation() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  void _onProfileTap(BuildContext context, Player player) {
    AudioManager.instance.playSfx(AudioSfx.click);
    _showPinDialog(context, player);
  }

  Future<void> _showPinDialog(BuildContext context, Player player) async {
    final pinController = TextEditingController();
    String? errorText;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/question background.png'),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${player.firstname}\'s PIN',
                      style: const TextStyle(fontSize: 22, color: colorBlack),
                    ),
                    const Gap(16),
                    TextField(
                      controller: pinController,
                      obscureText: true,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '● ● ● ●',
                        errorText: errorText,
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _PlankTextButton(
                          label: 'Cancel',
                          onTap: () => Navigator.of(ctx).pop(),
                        ),
                        _PlankTextButton(
                          label: 'Login',
                          onTap: () async {
                            final auth = context.read<AuthProvider>();
                            final success = await auth.login(
                                player, pinController.text);
                            if (success) {
                              if (context.mounted) {
                                Navigator.of(ctx).pop();
                                context.go(MainMenuScreen.path);
                              }
                            } else {
                              setDialogState(
                                  () => errorText = 'Wrong PIN. Try again.');
                              pinController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .scale(curve: Curves.elasticOut, duration: 500.ms)
                  .fade(),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Player player) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            image: const DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/question background.png'),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete Profile?',
                style: TextStyle(fontSize: 20, color: colorBlack),
              ),
              const Gap(8),
              Text(
                '${player.firstname} ${player.lastname}',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PlankTextButton(
                    label: 'Cancel',
                    onTap: () => Navigator.of(ctx).pop(false),
                  ),
                  _PlankTextButton(
                    label: 'Delete',
                    onTap: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<PlayerRepository>().deletePlayer(player);
      setState(() {}); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PlayerRepository>();
    final players = repo.getAllPlayers();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background ──────────────────────────────────────────────────────
          Image.asset('assets/images/background 2.png', fit: BoxFit.fill),

          // ── Logo ────────────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/correct logo.png',
                height: MediaQuery.sizeOf(context).height * 0.22,
                width: MediaQuery.sizeOf(context).width * 0.4,
              ),
            ),
          )
              .animate()
              .fade(duration: 700.ms)
              .moveY(begin: -40, end: 0, curve: Curves.easeOut),

          // ── Content ─────────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.24,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                const Text(
                  'Select Your Profile',
                  style: TextStyle(fontSize: 18, color: colorBlack),
                ).animate().fade(duration: 500.ms),
                const Gap(12),

                // ── Profile Cards ───────────────────────────────────────────
                Expanded(
                  child: players.isEmpty
                      ? Center(
                          child: const Text(
                            'No profiles yet.\nCreate one below!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: colorBlack),
                          ).animate().fade(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.05),
                          itemCount: players.length,
                          itemBuilder: (context, i) {
                            final player = players[i];
                            return _ProfileCard(
                              player: player,
                              onTap: () => _onProfileTap(context, player),
                              onDelete: () =>
                                  _confirmDelete(context, player),
                            )
                                .animate(delay: (i * 80).ms)
                                .fade(duration: 400.ms)
                                .slideX(begin: 0.3, curve: Curves.easeOut);
                          },
                        ),
                ),

                const Gap(12),

                // ── New Profile Button ───────────────────────────────────────
                GestureDetector(
                  onTap: () {
                    AudioManager.instance.playSfx(AudioSfx.click);
                    context.go(CreateProfileScreen.path);
                  },
                  child: Container(
                    height: 55,
                    width: 240,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/plank wood.png'),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'New Profile',
                        style: TextStyle(fontSize: 22, color: colorBlack),
                      ),
                    ),
                  ),
                )
                    .animate(delay: 300.ms)
                    .fade(duration: 500.ms)
                    .slideY(begin: 0.5, curve: Curves.easeOutBack),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Card ────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProfileCard({
    required this.player,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          image: const DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bg_square.png'),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown.shade200,
                image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/circle.png'),
                ),
              ),
              child: const Icon(Icons.person, size: 36, color: Colors.white),
            ),
            const Gap(8),
            Text(
              player.firstname,
              style: const TextStyle(fontSize: 14, color: colorBlack),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              player.section,
              style: const TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(8),
            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable plank button for dialogs ───────────────────────────────────────

class _PlankTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PlankTextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 110,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/plank wood.png'),
          ),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(fontSize: 16, color: colorBlack)),
        ),
      ),
    );
  }
}
