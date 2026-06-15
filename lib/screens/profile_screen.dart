import 'package:jasmieture_thesis/game/audio_manager.dart';
import 'package:jasmieture_thesis/models/game/player.dart';
import 'package:jasmieture_thesis/models/player_data.dart';
import 'package:jasmieture_thesis/repositories/audio_repository.dart';
import 'package:jasmieture_thesis/screens/login_screen.dart';
import 'package:jasmieture_thesis/view_models.dart/auth_provider.dart';
import 'package:jasmieture_thesis/view_models.dart/quiz_data.dart';
import 'package:jasmieture_thesis/widgets/plank_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const path = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();

  Player? player;

  final firstnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final lastnameController = TextEditingController();
  final sectionController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    player = context.read<AuthProvider>().currentPlayer;
    if (player != null) {
      firstnameController.text = player!.firstname;
      middlenameController.text = player!.middlename;
      lastnameController.text = player!.lastname;
      sectionController.text = player!.section;
      ageController.text = player!.age.toString();
    }
  }

  String? stringValidator(String? value) =>
      (value == null || value.isEmpty) ? 'Fill this field.' : null;

  // ── History ──────────────────────────────────────────────────────────────────

  Widget _buildHistorySection() {
    if (player == null || !player!.isInBox) return const SizedBox.shrink();

    final histories = context
        .read<QuizData>()
        .historiesForPlayer(player!.key as int);

    if (histories.isEmpty) {
      return const Text('No game history yet.',
          style: TextStyle(fontSize: 13));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Game History', style: TextStyle(fontSize: 15)),
        const Gap(8),
        ...histories.reversed.take(10).map(
              (h) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lvl ${h.level} · Ch ${h.chapter}',
                        style: const TextStyle(fontSize: 12)),
                    Text('Score: ${h.score}',
                        style: const TextStyle(fontSize: 12)),
                    Text('${h.timeTaken}s',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/question background.png')),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.15,
                  right: constraints.maxWidth * 0.15,
                  top: constraints.maxHeight * 0.18,
                  bottom: constraints.maxHeight * 0.18,
                ),
                child: SingleChildScrollView(
                  clipBehavior: Clip.hardEdge,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),

                        // ── Row 1: First & Middle Name ────────────────────────
                        Row(
                          spacing: 14,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('First name'),
                                  TextFormField(
                                    controller: firstnameController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Middle name'),
                                  TextFormField(
                                    controller: middlenameController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            .animate(delay: 200.ms)
                            .fade(duration: 500.ms)
                            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

                        const SizedBox(height: 14),

                        // ── Row 2: Last Name & Section ────────────────────────
                        Row(
                          spacing: 14,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Last name'),
                                  TextFormField(
                                    controller: lastnameController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Section'),
                                  TextFormField(
                                    controller: sectionController,
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            .animate(delay: 300.ms)
                            .fade(duration: 500.ms)
                            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

                        const SizedBox(height: 14),

                        // ── Row 3: Age & Update ───────────────────────────────
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Age'),
                                  TextFormField(
                                    controller: ageController,
                                    decoration: const InputDecoration(),
                                    validator: stringValidator,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: PlankButton(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    player
                                      ?..firstname = firstnameController.text
                                      ..lastname = lastnameController.text
                                      ..middlename = middlenameController.text
                                      ..section = sectionController.text
                                      ..age = int.tryParse(ageController.text) ??
                                          0;

                                    await context
                                        .read<PlayerData>()
                                        .playerRepository
                                        .updatePlayer(player!);

                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0, 0, 0, 0),
                                            child: Container(
                                              height: 280,
                                              width: 400,
                                              padding:
                                                  const EdgeInsets.all(40),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/Completed Menu.png')),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    size: 80,
                                                    color: Colors.green.shade500,
                                                  )
                                                      .animate()
                                                      .scale(
                                                          curve: Curves
                                                              .elasticOut,
                                                          duration: 600.ms),
                                                  const Text(
                                                    'Profile Updated',
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  PlankButton(
                                                    onTap: () {
                                                      AudioManager.instance
                                                          .playSfx(
                                                              AudioSfx.click);
                                                      context.pop();
                                                    },
                                                    label: 'Ok',
                                                  ),
                                                ],
                                              ),
                                            )
                                                .animate()
                                                .scale(
                                                    curve:
                                                        Curves.elasticOut,
                                                    duration: 500.ms)
                                                .fade(),
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                label: 'Update',
                              ),
                            ),
                          ],
                        )
                            .animate(delay: 400.ms)
                            .fade(duration: 500.ms)
                            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),

                        const SizedBox(height: 20),

                        // ── Game History ──────────────────────────────────────
                        _buildHistorySection()
                            .animate(delay: 500.ms)
                            .fade(duration: 500.ms),

                        const SizedBox(height: 14),

                        // ── Logout Button ─────────────────────────────────────
                        Center(
                          child: PlankButton(
                            onTap: () async {
                              AudioManager.instance.playSfx(AudioSfx.click);
                              await context.read<AuthProvider>().logout();
                              if (context.mounted) {
                                context.go(LoginScreen.path);
                              }
                            },
                            label: 'Logout',
                          ),
                        )
                            .animate(delay: 600.ms)
                            .fade(duration: 500.ms)
                            .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Title Image ─────────────────────────────────────────────────
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.01,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/images/player profile.png',
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    width: MediaQuery.sizeOf(context).width * 0.45),
              ),
            )
                .animate()
                .fade(duration: 500.ms)
                .moveY(begin: -50, end: 0, curve: Curves.easeOut),

            // ── Back Arrow ──────────────────────────────────────────────────
            Positioned(
              height: MediaQuery.sizeOf(context).height * 0.1,
              width: MediaQuery.sizeOf(context).width * 0.1,
              top: 14,
              left: 14,
              child: InkWell(
                onTap: () {
                  AudioManager.instance.playSfx(AudioSfx.click);
                  context.go('/');
                },
                child: Image.asset('assets/images/back arrow.png'),
              ),
            )
                .animate(delay: 200.ms)
                .fade()
                .moveX(begin: -30, end: 0, curve: Curves.easeOut),
          ],
        );
      }),
    );
  }
}