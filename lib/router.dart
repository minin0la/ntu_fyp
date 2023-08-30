// loggedOut
// loggedIn

import 'package:flutter/material.dart';
import 'package:pet_app/main.dart';
import 'package:pet_app/features/auth/screens/login_screen.dart';
import 'package:pet_app/features/home/screens/home_screen.dart';
import 'package:pet_app/features/auth/screens/signup_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: LoginPageScreen()),
  '/signup': (_) => MaterialPage(child: SignupScreen()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: MyHomePage()),
});
