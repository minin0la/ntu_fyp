// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pet_app/models/pet_model.dart';

class UserModel {
  final String firstname;
  final String lastname;
  final String phonenumber;
  final String email;
  final String uid;
  final bool isAuthenticated;
  final String profilePic;
  final List<Map> pets;
  UserModel({
    required this.firstname,
    required this.lastname,
    required this.phonenumber,
    required this.email,
    required this.uid,
    required this.isAuthenticated,
    required this.profilePic,
    required this.pets,
  });

  UserModel copyWith({
    String? firstname,
    String? lastname,
    String? phonenumber,
    String? email,
    String? uid,
    bool? isAuthenticated,
    String? profilePic,
    List<Map>? pets,
  }) {
    return UserModel(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      profilePic: profilePic ?? this.profilePic,
      pets: pets ?? this.pets,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'lastname': lastname,
      'phonenumber': phonenumber,
      'email': email,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'profilePic': profilePic,
      'pets': pets,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      phonenumber: map['phonenumber'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      profilePic: map['profilePic'] as String,
      pets: List<Map>.from(
        (map['pets']),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(firstname: $firstname, lastname: $lastname, phonenumber: $phonenumber, email: $email, uid: $uid, isAuthenticated: $isAuthenticated, profilePic: $profilePic, pets: $pets)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.firstname == firstname &&
        other.lastname == lastname &&
        other.phonenumber == phonenumber &&
        other.email == email &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.profilePic == profilePic &&
        listEquals(other.pets, pets);
  }

  @override
  int get hashCode {
    return firstname.hashCode ^
        lastname.hashCode ^
        phonenumber.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        profilePic.hashCode ^
        pets.hashCode;
  }
}
