import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreen();
}

class _ChangePasswordScreen extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void changePassword(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).changePassword(
        _oldPasswordController.text, _newPasswordController.text, context);
  }

  void navigateToMain(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: isLoading
          ? const Loader()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text('Change Password',
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
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Old Password',
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                      ),
                      keyboardType: TextInputType.visiblePassword,
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
            ),
    );
  }
}
