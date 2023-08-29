// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pet_app/screens/login_screen.dart';
// import 'package:pet_app/models/user_model.dart';

// class UserManager {
//   final _db = FirebaseFirestore.instance;

//   createUser(UserModel user, email, password) async {
//     try {
//       final newUser = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       await _db
//           .collection("Users")
//           .doc(newUser.user!.uid)
//           .set(user.toJson())
//           .catchError((error, stackTrace) {
//         print(error.toString());
//       });
//       return true;
//     } catch (error) {
//       return false;
//       // print("Error: ${error.toString()}");
//     }
//   }
// }
