import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pet_app/constants/firebase_constants.dart';
import 'package:pet_app/failure.dart';
import 'package:pet_app/models/user_model.dart';
import 'package:pet_app/providers/firebase_providers.dart';
import 'package:pet_app/type_defs.dart';

final authRepoProvider = Provider((ref) => AuthRepo(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
    ));

class AuthRepo {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepo({required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _firestore = firestore,
        _auth = auth;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      late UserModel userModel;
      // print(userCredential.user?.email);
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            email: email,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            profilePic:
                "https://cdn.vectorstock.com/i/preview-1x/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.jpg",
            pets: []);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
