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
      return right(_pets.doc().set(pet.toMap()));
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
      return pets;
    });
  }

  CollectionReference get _pets =>
      _firestore.collection(FirebaseConstants.petsCollection);
}
