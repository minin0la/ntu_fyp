import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_app/screens/login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pushReplacement(
        new MaterialPageRoute(builder: (context) => new LoginPage()),
      );
    } catch (e) {
      // Handle error if logout fails
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Edit Profile'),
                onTap: () {
                  // Handle edit profile action
                },
              ),
              ListTile(
                title: Text('Change Password'),
                onTap: () {
                  // Handle change password action
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  _logout(context);
                },
              ),
              Divider(),
              Text(
                'Notification Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SwitchListTile(
                title: Text('Email Notifications'),
                value: true,
                onChanged: (value) {
                  // Handle email notification toggle
                },
              ),
              SwitchListTile(
                title: Text('Push Notifications'),
                value: true,
                onChanged: (value) {
                  // Handle push notification toggle
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
