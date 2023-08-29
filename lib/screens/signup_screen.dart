import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/controller/auth_controller.dart';
import 'package:pet_app/screens/login_screen.dart';
import 'package:pet_app/utils/user_manager.dart';
import 'package:pet_app/models/user_model.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signUpWithEmailAndPassword(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider).signUpWithEmailAndPassword(
        _emailController.text, _passwordController.text, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                onPressed: () => signUpWithEmailAndPassword(context, ref),
                // onPressed: () async {
                //   final user =
                //       UserModel(email: _emailController.text.trim(), pets: []);

                //   UserManager()
                //       .createUser(user, _emailController.text.trim(),
                //           _passwordController.text.trim())
                //       .then((result) => {
                //             if (result)
                //               {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                             LoginPageScreen())),
                //                 const SnackBar(
                //                     content: Text(
                //                         'Success, Your account has been created'))
                //               }
                //             else
                //               {
                //                 const SnackBar(
                //                     content: Text(
                //                         'Error, Something went wrong. Try again'))
                //               }
                //           });
                // },
                child: const Text('Sign up')),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPageScreen()));
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
