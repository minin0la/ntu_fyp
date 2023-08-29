import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/repo/auth_repo.dart';

import '../utils.dart';

final authControllerProvider =
    Provider((ref) => AuthController(authRepo: ref.read(authRepoProvider)));

class AuthController {
  final AuthRepo _authRepo;
  AuthController({required AuthRepo authRepo}) : _authRepo = authRepo;

  void signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    final user = await _authRepo.signUpWithEmailAndPassword(email, password);
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }
}
