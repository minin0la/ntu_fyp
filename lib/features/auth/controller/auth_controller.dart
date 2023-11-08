import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/features/auth/repo/auth_repo.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/user_model.dart';
import '../../../core/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(authRepo: ref.watch(authRepoProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserdata(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepo _authRepo;
  final Ref _ref;
  AuthController({required AuthRepo authRepo, required Ref ref})
      : _authRepo = authRepo,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepo.authStateChanges;

  void signUpWithEmailAndPassword(
      String firstname,
      String lastname,
      String phonenumber,
      String email,
      String password,
      BuildContext context) async {
    state = true;
    final user = await _authRepo.signUpWithEmailAndPassword(
        firstname, lastname, phonenumber, email, password);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) {
      Routemaster.of(context).pop();
    });
  }

  void signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    state = true;
    final user = await _authRepo.signInWithEmailAndPassword(email, password);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
    });
  }

  Stream<UserModel> getUserdata(String uid) {
    return _authRepo.getUserdata(uid);
  }

  void logout() async {
    _authRepo.logOut();
  }
}
