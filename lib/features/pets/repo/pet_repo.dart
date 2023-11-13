import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pet_app/core/constants/firebase_constants.dart';
import 'package:pet_app/core/failure.dart';
import 'package:pet_app/core/providers/firebase_providers.dart';
import 'package:pet_app/core/type_defs.dart';
import 'package:pet_app/models/pet_model.dart';

final petRepoProvider = Provider((ref) {
  return PetRepo(firestore: ref.watch(firestoreProvider));
});

class PetRepo {
  final FirebaseFirestore _firestore;
  PetRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureVoid addPet(PetModel pet) async {
    try {
      String petID;
      petID = _pets.doc().id;
      pet = pet.copyWith(id: petID);
      return right(_pets.doc(petID).set(pet.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Check in Pets collection if any pets has the same petOwnerid. Should add in the list.
  Stream<List<PetModel>> getUserPets(String uid) {
    return _pets.where('ownerid', isEqualTo: uid).snapshots().map((event) {
      List<PetModel> pets = [];
      for (var doc in event.docs) {
        pets.add(PetModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      // print("UPDATED");
      return pets;
    });
  }

  Stream<List<String>> getUserPetsNames(String uid) {
    return _pets.where('ownerid', isEqualTo: uid).snapshots().map((event) {
      List<String> pets = [];
      for (var doc in event.docs) {
        pets.add(PetModel.fromMap(doc.data() as Map<String, dynamic>).name);
      }
      return pets;
    });
  }

  // Stream<List<PetModel>> getPetsAttention(String uid) {
  //   return _pets.where('ownerid', isEqualTo: uid).snapshots().map((event) {
  //     List<PetModel> pets = [];
  //     for (var doc in event.docs) {
  //       PetModel pet = PetModel.fromMap(doc.data() as Map<String, dynamic>);
  //       if (DateTime.now().difference(pet.lastbath).inSeconds > 5) {
  //         pets.add(pet);
  //       }
  //     }
  //     return pets;
  //   });
  // }

  Stream<PetModel> getPetByID(String petID) {
    return _pets
        .doc(petID)
        .snapshots()
        .map((event) => PetModel.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _pets =>
      _firestore.collection(FirebaseConstants.petsCollection);

  FutureVoid deletePet(PetModel pet) async {
    try {
      return right(_pets.doc(pet.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid setPet(PetModel pet) async {
    try {
      return right(_pets.doc(pet.id).set(pet.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editPet(PetModel pet) async {
    try {
      return right(_pets.doc(pet.id).update(pet.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
