import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/repo/auth_repo.dart';
import 'package:pet_app/features/auth/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signUpWithEmailAndPassword(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signUpWithEmailAndPassword(
        _firstnameController.text,
        _lastnameController.text,
        _phonenumberController.text,
        _emailController.text,
        _passwordController.text,
        context);
  }

  // void navigateToSignIn(BuildContext context, WidgetRef ref) {
  //   ref.read(authRepoProvider.
  //   Routemaster.of(context).push('/');
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign Up',
                      style: GoogleFonts.getFont(
                        'Dancing Script',
                        textStyle: const TextStyle(
                          fontSize: 46,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 30.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstnameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: _lastnameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _phonenumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () => signUpWithEmailAndPassword(context, ref),
                      child: const Text('Sign up')),
                  TextButton(
                    onPressed: () {
                      Routemaster.of(context).pop();
                    },
                    child: const Text(
                      'Have an account? Login here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
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
