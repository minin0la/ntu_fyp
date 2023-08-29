import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/main.dart';
import 'package:pet_app/screens/signup_screen.dart';
import 'package:pet_app/utils/popupDialog.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  _LoginPageScreenState createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Petter',
                style: GoogleFonts.getFont(
                  'Dancing Script',
                  textStyle: TextStyle(
                    fontSize: 46,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(height: 30),
            Image.asset(
              "assets/login_pet.gif",
              width: 200,
              height: 200,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                } catch (error) {
                  showErrorDialog(context, error.toString());

                  // print("Error: ${error.toString()}");
                }
              },
              child: Text('Login'),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.deepOrange)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: Text(
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
