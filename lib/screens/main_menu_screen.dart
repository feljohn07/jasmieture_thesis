import 'package:jasmieture_thesis/models/settings.dart';
import 'package:jasmieture_thesis/core/shared/colors.dart';
import 'package:jasmieture_thesis/game/audio_manager.dart';
import 'package:jasmieture_thesis/repositories/audio_repository.dart';
import 'package:jasmieture_thesis/view_models.dart/auth_provider.dart';
import 'package:jasmieture_thesis/view_models.dart/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:jasmieture_thesis/view_models.dart/shop_data.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  static const path = '/';

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<SettingsData>().bgm) {
      AudioManager.instance.startBgm(context.read<SettingsData>().bgmPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/background 2.png',
                fit: BoxFit.fill,
              ),
              Positioned(
                top: constraints.maxHeight * 0.30,
                left: constraints.maxHeight * 0.03,
                child: Container(
                  height: constraints.maxHeight * 0.65,
                  width: constraints.maxWidth * 0.95,
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.1),
                  child: Center(
                    child: Column(
                      children: [
                        // --- BUTTON 1: LEVELS ---
                        InkWell(
                          child: Container(
                            height: 75,
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/plank wood.png'))),
                            child: Center(
                                child: const Text('Levels',
                                    style: TextStyle(
                                        fontSize: 30, color: colorBlack))),
                          ),
                          onTap: () {
                            AudioManager.instance.playSfx(AudioSfx.click);
                            context.go('/levels');
                          },
                        )
                            .animate() // Start Animation
                            .fade(duration: 600.ms)
                            .slideY(
                                begin: 0.5,
                                curve: Curves.easeOutBack) // Bouncy entry
                            .shimmer(
                                delay: 1500.ms,
                                duration: 1500.ms), // Periodic shine

                        SizedBox(height: 4),

                        // --- BUTTON 2: SHOP ---
                        InkWell(
                          child: Container(
                            height: 75,
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/plank wood.png'))),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 14,
                              children: [
                                Text(context.watch<LanguageProvider>().shop,
                                    style: TextStyle(
                                        fontSize: 30, color: colorBlack)),
                              ],
                            )),
                          ),
                          onTap: () {
                            AudioManager.instance.playSfx(AudioSfx.click);
                            context.go('/shop');
                          },
                        )
                            .animate(delay: 100.ms) // Wait 100ms
                            .fade(duration: 600.ms)
                            .slideY(begin: 0.5, curve: Curves.easeOutBack),

                        SizedBox(height: 4),

                        SizedBox(
                          width: 300,
                          child: Row(
                            spacing: 4,
                            children: [
                              // --- BUTTON 3: SETTINGS ---
                              InkWell(
                                child: Container(
                                  height: 75,
                                  width: 220,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/plank wood.png'))),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 14,
                                    children: [
                                      const Text('Settings',
                                          style: TextStyle(
                                              fontSize: 30, color: colorBlack)),
                                    ],
                                  )),
                                ),
                                onTap: () {
                                  AudioManager.instance.playSfx(AudioSfx.click);
                                  context.go('/settings');
                                },
                              )
                                  .animate(delay: 200.ms) // Wait 200ms
                                  .fade(duration: 600.ms)
                                  .slideY(
                                      begin: 0.5, curve: Curves.easeOutBack),

                              // --- BUTTON 4: PROFILE ---
                              InkWell(
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/circle.png'))),
                                  child: Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  AudioManager.instance.playSfx(AudioSfx.click);
                                  context.go('/profile');
                                },
                              )
                                  .animate(delay: 300.ms) // Wait 300ms
                                  .fade(duration: 600.ms)
                                  .scale(
                                      curve:
                                          Curves.elasticOut), // Pop in effect
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.03,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset('assets/images/correct logo.png',
                      height: MediaQuery.sizeOf(context).height * 0.25,
                      width: MediaQuery.sizeOf(context).width * 0.45),
                ),
              )
                  .animate()
                  .fade(duration: 800.ms)
                  .moveY(begin: -50, end: 0, curve: Curves.easeOut),

              // ── Stars badge ────────────────────────────────────
              Positioned(
                top: 10,
                left: 14,
                child: Builder(builder: (ctx) {
                  final stars = ctx.watch<ShopData>().star;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade700.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amberAccent, size: 14),
                        const SizedBox(width: 4),
                        Text('$stars',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                      .animate()
                      .fade(duration: 600.ms)
                      .slideX(begin: -0.3, curve: Curves.easeOut);
                }),
              ),

              // ── Logged-in player badge ────────────────────────────────────
              Positioned(
                top: 10,
                right: 14,
                child: Builder(builder: (ctx) {
                  final name =
                      ctx.watch<AuthProvider>().currentPlayer?.firstname ?? '';
                  if (name.isEmpty) return const SizedBox.shrink();
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade700.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  )
                      .animate()
                      .fade(duration: 600.ms)
                      .slideX(begin: 0.3, curve: Curves.easeOut);
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
