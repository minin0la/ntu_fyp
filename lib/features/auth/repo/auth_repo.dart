import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pet_app/core/constants/firebase_constants.dart';
import 'package:pet_app/core/failure.dart';
import 'package:pet_app/models/user_model.dart';
import 'package:pet_app/core/providers/firebase_providers.dart';
import 'package:pet_app/core/type_defs.dart';

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

  // Check if any data change in user
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signUpWithEmailAndPassword(
      String firstname,
      String lastname,
      String phonenumber,
      String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel;
      userModel = UserModel(
          firstname: firstname,
          lastname: lastname,
          phonenumber: phonenumber,
          email: email,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          profilePic:
              "https://cdn.vectorstock.com/i/preview-1x/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.jpg",
          pets: []);
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      //if error, return left with a error string
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel;
      // Check if new user.
      userModel = await getUserdata(userCredential.user!.uid).first;
      // if not error, return userModel
      return right(userModel);
      // } on FirebaseException catch (e) {
      // throw e.message!;
    } catch (e) {
      //if error, return left with a error string
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> changePassword(
      String email, String oldPassword, String newPassword) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: oldPassword);
      await userCredential.user!.updatePassword(newPassword);
      UserModel userModel;
      // Check if new user.
      userModel = await getUserdata(userCredential.user!.uid).first;
      // if not error, return userModel
      return right(userModel);
      // } on FirebaseException catch (e) {
      // throw e.message!;
    } catch (e) {
      //if error, return left with a error string
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right('success');
    } catch (e) {
      //if error, return left with a error string
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserdata(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    // await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
