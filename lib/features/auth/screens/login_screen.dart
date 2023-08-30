import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/auth_controller.dart';

class LoginPageScreen extends ConsumerWidget {
  LoginPageScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signInWithEmailAndPassword(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
        _emailController.text, _passwordController.text, context);
  }

  void navigateToMain(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Loader()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Petter',
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
                    "assets/login_pet.gif",
                    width: 200,
                    height: 200,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => signInWithEmailAndPassword(context, ref),
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.deepOrange)),
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: const Text(
                      'No account? Sign up here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFF5722),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
