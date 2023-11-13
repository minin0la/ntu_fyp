import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends ConsumerState<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  void changePassword(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .resetPassword(_emailController.text, context);
  }

  void navigateToMain(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: isLoading
          ? const Loader()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Reset Password',
                      style: GoogleFonts.getFont(
                        'Dancing Script',
                        textStyle: const TextStyle(
                          fontSize: 46,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 30),
                  Image.asset(
                    "assets/login_pet.png",
                    width: 200,
                    height: 200,
                  ),
                  TextField(
                    controller: _emailController,
                    // obscureText: true,17
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => changePassword(context, ref),
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.deepOrange)),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _oldPasswordController {}
