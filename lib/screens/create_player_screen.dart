import 'package:jasmieture_thesis/models/game/player.dart';
import 'package:jasmieture_thesis/models/player_data.dart';
import 'package:jasmieture_thesis/screens/login_screen.dart';
import 'package:jasmieture_thesis/view_models.dart/auth_provider.dart';
import 'package:jasmieture_thesis/screens/main_menu_screen.dart';
import 'package:jasmieture_thesis/widgets/plank_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  static const path = '/create-profile-screen';

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final lastnameController = TextEditingController();
  final sectionController = TextEditingController();
  final ageController = TextEditingController();
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  DateTime? dateOfBirth;

  String? stringValidator(String? value) =>
      (value == null || value.isEmpty) ? 'Fill this field.' : null;

  String? pinValidator(String? value) {
    if (value == null || value.isEmpty) return 'Enter a 4-digit PIN.';
    if (value.length != 4) return 'PIN must be exactly 4 digits.';
    if (!RegExp(r'^\d{4}$').hasMatch(value)) return 'Digits only.';
    return null;
  }

  String? confirmPinValidator(String? value) {
    if (value != pinController.text) return 'PINs do not match.';
    return null;
  }

  @override
  initState() {
    super.initState();
    setHorizontalMode();
  }

  Future<void> setHorizontalMode() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  int page = 0;

  void next() {
    if (page >= 5) return;
    setState(() => page++);
  }

  void back() {
    if (page <= 0) return;
    setState(() => page--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:
                        AssetImage('assets/images/question background.png')),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.12,
              left: MediaQuery.sizeOf(context).width * 0.15,
              right: MediaQuery.sizeOf(context).width * 0.15,
              bottom: MediaQuery.sizeOf(context).height * 0.20,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Step 0: First Name ──────────────────────────────────
                    Visibility(
                      visible: page == 0,
                      child: _stepCard(
                        title: 'First Name',
                        child: TextFormField(
                          controller: firstnameController,
                          decoration:
                              const InputDecoration(hintText: 'Enter Firstname'),
                          textAlign: TextAlign.center,
                          validator: stringValidator,
                        ),
                        onNext: next,
                      ),
                    ),

                    // ── Step 1: Middle Name ─────────────────────────────────
                    Visibility(
                      visible: page == 1,
                      child: _stepCard(
                        title: 'Middle Name',
                        child: TextFormField(
                          controller: middlenameController,
                          decoration:
                              const InputDecoration(hintText: 'Enter Middlename'),
                          textAlign: TextAlign.center,
                          validator: stringValidator,
                        ),
                        onNext: next,
                        onBack: back,
                      ),
                    ),

                    // ── Step 2: Last Name ───────────────────────────────────
                    Visibility(
                      visible: page == 2,
                      child: _stepCard(
                        title: 'Last Name',
                        child: TextFormField(
                          controller: lastnameController,
                          decoration:
                              const InputDecoration(hintText: 'Enter Lastname'),
                          textAlign: TextAlign.center,
                          validator: stringValidator,
                        ),
                        onNext: next,
                        onBack: back,
                      ),
                    ),

                    // ── Step 3: Section ─────────────────────────────────────
                    Visibility(
                      visible: page == 3,
                      child: _stepCard(
                        title: "What's your Section?",
                        child: TextFormField(
                          controller: sectionController,
                          decoration: const InputDecoration(
                              hintText: 'Enter your Section'),
                          validator: stringValidator,
                        ),
                        onNext: next,
                        onBack: back,
                      ),
                    ),

                    // ── Step 4: Age ─────────────────────────────────────────
                    Visibility(
                      visible: page == 4,
                      child: _stepCard(
                        title: 'How Old are you?',
                        child: TextFormField(
                          controller: ageController,
                          decoration:
                              const InputDecoration(hintText: 'Age'),
                          keyboardType:
                              const TextInputType.numberWithOptions(),
                          validator: stringValidator,
                        ),
                        onNext: next,
                        onBack: back,
                      ),
                    ),

                    // ── Step 5: Set PIN ─────────────────────────────────────
                    Visibility(
                      visible: page == 5,
                      child: Column(
                        children: [
                          const Text(
                            'Set a 4-digit PIN',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Gap(8),
                          TextFormField(
                            controller: pinController,
                            obscureText: true,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: '● ● ● ●',
                              counterText: '',
                            ),
                            validator: pinValidator,
                          ),
                          const Gap(12),
                          TextFormField(
                            controller: confirmPinController,
                            obscureText: true,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Confirm PIN',
                              counterText: '',
                            ),
                            validator: confirmPinValidator,
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PlankButton(onTap: back, label: 'Back'),
                              PlankButton(
                                onTap: () async {
                                  if (!formKey.currentState!.validate()) return;
                                  final player = Player(
                                    firstname: firstnameController.text,
                                    lastname: lastnameController.text,
                                    middlename: middlenameController.text,
                                    section: sectionController.text,
                                    age:
                                        int.tryParse(ageController.text) ?? 0,
                                    pin: pinController.text,
                                  );
                                  final playerRepo = context.read<PlayerData>().playerRepository;
                                  final auth = context.read<AuthProvider>();
                                  await playerRepo.createPlayer(player);
                                  await setHorizontalMode();
                                  // Auto-login after registration
                                  await auth.login(player, player.pin);
                                  if (context.mounted) {
                                    context.go(MainMenuScreen.path);
                                  }
                                },
                                label: 'Start!',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Back to Login ────────────────────────────────────────────────
            Positioned(
              top: 10,
              left: 10,
              child: TextButton.icon(
                onPressed: () => context.go(LoginScreen.path),
                icon: const Icon(Icons.arrow_back, color: Colors.brown),
                label: const Text('Login',
                    style: TextStyle(color: Colors.brown)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCard({
    required String title,
    required Widget child,
    required VoidCallback onNext,
    VoidCallback? onBack,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const Gap(8),
          child,
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (onBack != null) PlankButton(onTap: onBack, label: 'Back'),
              PlankButton(
                onTap: () {
                  if (formKey.currentState!.validate()) onNext();
                },
                label: 'Next',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
