import 'package:flutter/material.dart';
import 'package:pet_app/features/auth/screens/changepw_screen.dart';
import 'package:pet_app/features/auth/screens/forgetpw_screen.dart';
import 'package:pet_app/features/pets/screens/addpet_screen.dart';
import 'package:pet_app/features/pets/screens/editpet_screen.dart';
import 'package:pet_app/features/pets/screens/pet_screen.dart';
import 'package:pet_app/main.dart';
import 'package:pet_app/features/auth/screens/login_screen.dart';
import 'package:pet_app/features/auth/screens/signup_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: LoginPageScreen()),
  '/signup': (_) => MaterialPage(child: SignupScreen()),
  '/forgetpw': (_) => const MaterialPage(child: ForgetPasswordScreen()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: MyHomePage()),
  '/add-pet': (_) => const MaterialPage(child: AddPetScreen()),
  '/pets/:petID': (route) =>
      MaterialPage(child: PetScreen(petID: route.pathParameters['petID']!)),
  '/edit-pets/:petID': (route) =>
      MaterialPage(child: EditPetScreen(petID: route.pathParameters['petID']!)),
  '/changepw': (route) => const MaterialPage(child: ChangePasswordScreen()),
});
