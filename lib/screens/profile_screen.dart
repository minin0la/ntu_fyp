import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/pets/screens/addpet_screen.dart';
import 'package:routemaster/routemaster.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text('Petter',
                  style: GoogleFonts.getFont(
                    'Dancing Script',
                    textStyle: const TextStyle(
                      fontSize: 48,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 8),
              const Text(
                'General Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // ListTile(
              //   title: const Text('Edit Profile'),
              //   onTap: () {
              //     // Handle edit profile action
              //   },
              // ),
              // ListTile(
              //   title: const Text('Edit Pets'),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const AddPetScreen()));
              //     // Handle edit profile action
              //   },
              // ),
              ListTile(
                title: const Text('Change Password'),
                onTap: () {
                  Routemaster.of(context).push('/changepw');
                  // Handle change password action
                },
              ),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  logOut(ref);
                },
              ),
              // const Divider(),
              // const Text(
              //   'Notification Settings',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 10),
              // SwitchListTile(
              //   title: const Text('Email Notifications'),
              //   value: true,
              //   onChanged: (value) {
              //     // Handle email notification toggle
              //   },
              // ),
              // SwitchListTile(
              //   title: const Text('Push Notifications'),
              //   value: true,
              //   onChanged: (value) {
              //     // Handle push notification toggle
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
