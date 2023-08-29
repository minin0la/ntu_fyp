// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pet_app/models/pet_model.dart';

class UserModel {
  final String email;
  final String uid;
  final bool isAuthenticated;
  final String profilePic;
  final List<PetModel> pets;
  UserModel({
    required this.email,
    required this.uid,
    required this.isAuthenticated,
    required this.profilePic,
    required this.pets,
  });

  UserModel copyWith({
    String? email,
    String? uid,
    bool? isAuthenticated,
    String? profilePic,
    List<PetModel>? pets,
  }) {
    return UserModel(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      profilePic: profilePic ?? this.profilePic,
      pets: pets ?? this.pets,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'profilePic': profilePic,
      'pets': pets.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      profilePic: map['profilePic'] as String,
      pets: List<PetModel>.from(
        (map['pets'] as List<int>).map<PetModel>(
          (x) => PetModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, uid: $uid, isAuthenticated: $isAuthenticated, profilePic: $profilePic, pets: $pets)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.profilePic == profilePic &&
        listEquals(other.pets, pets);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        profilePic.hashCode ^
        pets.hashCode;
  }
}
