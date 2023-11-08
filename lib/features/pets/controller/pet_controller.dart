import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/constants/constants.dart';
import 'package:pet_app/core/providers/storage_repo_providers.dart';
import 'package:pet_app/core/utils.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/pets/repo/pet_repo.dart';
import 'package:pet_app/models/pet_model.dart';
import 'package:routemaster/routemaster.dart';

final petProvider = StateProvider<PetModel?>((ref) => null);

final userPetsProvider = StreamProvider((ref) {
  final petController = ref.watch(petControllerProvider.notifier);
  return petController.getUserPets();
});
final userPetsNamesProvider = StreamProvider((ref) {
  final petController = ref.watch(petControllerProvider.notifier);
  return petController.getUserPetsNames();
});

// final getPetsAttentionProvider = StreamProvider((ref) {
//   final petController = ref.watch(petControllerProvider.notifier);
//   return petController.getPetsAttention();
// });

final getPetByIDProvider = StreamProvider.family((ref, String petID) {
  final petController = ref.watch(petControllerProvider.notifier);
  return petController.getPetByID(petID);
});

final petControllerProvider = StateNotifierProvider<PetController, bool>((ref) {
  final petRepo = ref.watch(petRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return PetController(petRepo: petRepo, ref: ref, storageRepo: storageRepo);
});

// final petLoopProvider = StateNotifierProvider<PetLoop, AsyncValue>((ref) {
//   final petRepo = ref.watch(petRepoProvider);
//   return PetLoop(petRepo: petRepo, ref: ref);
// });

// class PetLoop extends StateNotifier<AsyncValue> {
//   final Ref _ref;
//   PetLoop({
//     required PetRepo petRepo,
//     required Ref ref,
//   })  : _ref = ref,
//         super(const AsyncValue.loading()) {
//     getPetsLoop(const Duration(seconds: 5));
//   }

//   Future<void> getPetsLoop(Duration delay) async {
//     while (true) {
//       try {
//         final data = _ref.read(userPetsProvider);
//         List<PetModel> pets = [];
//         for (var pet in data.value!) {
//           pets.add(pet);
//         }
//         state = AsyncValue.data(pets);
//       } catch (e) {
//         state = AsyncValue.error(e, StackTrace.current);
//       }
//       await Future.delayed(delay);
//     }
//   }
// }

final petAttentionProvider =
    StateNotifierProvider<PetAttentionController, List<PetModel>>((ref) {
  final petRepo = ref.watch(petRepoProvider);

  return PetAttentionController(petRepo, ref);
});

class PetAttentionController extends StateNotifier<List<PetModel>> {
  PetAttentionController(this.petRepo, this.ref) : super([]) {
    checkAttention();
  }
  final PetRepo petRepo;
  final Ref ref;

  Future<void> checkAttention() async {
    try {
      final data = ref.watch(userPetsProvider);
      List<PetModel> pets = [];
      for (var pet in data.value!) {
        if (DateTime.now().difference(pet.lastbath).inHours > 24 ||
            DateTime.now().difference(pet.lastfeeding).inHours > 6 ||
            DateTime.now().difference(pet.lastwalk).inHours > 6 ||
            DateTime.now().difference(pet.lastplaytime).inHours > 3) {
          pets.add(pet);
        }
      }
      state = pets;
    } catch (e) {
      state = [];
    }
    Future.delayed(const Duration(seconds: 1), checkAttention);
  }
}

final petRoutineProvider =
    StateNotifierProvider.family<PetRoutineController, bool, List>((ref, time) {
  return PetRoutineController(time);
});

class PetRoutineController extends StateNotifier<bool> {
  PetRoutineController(this.time) : super(false) {
    checkRoutine();
  }
  final List time;

  void checkRoutine() {
    if (DateTime.now().difference(time[0]).inHours > time[1]) {
      state = true;
    }
    Future.delayed(const Duration(seconds: 5), checkRoutine);
  }
}

class PetController extends StateNotifier<bool> {
  final PetRepo _petRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  PetController({
    required PetRepo petRepo,
    required Ref ref,
    required StorageRepo storageRepo,
  })  : _petRepo = petRepo,
        _ref = ref,
        _storageRepo = storageRepo,
        super(false);

  void addPet(String petName, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    PetModel pet = PetModel(
      ownerid: uid,
      avatar: Constants.avatarDefault,
      name: petName,
      type: "",
      breed: "",
      age: 0,
      weight: 0,
      vaccinated: true,
      neutered: true,
      microchip: true,
      birthday: DateTime.now(),
      lastvetvisit: DateTime.now(),
      lastgrooming: DateTime.now(),
      lastwalk: DateTime.now(),
      lastbath: DateTime.now(),
      lastmedication: DateTime.now(),
      lastplaytime: DateTime.now(),
      lastfeeding: DateTime.now(),
    );
    final res = await _petRepo.addPet(pet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), ((r) {
      Routemaster.of(context).pop();
    }));
  }

  void deletePet(PetModel pet, BuildContext context) async {
    final res = await _petRepo.deletePet(pet);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  // Stream the list of pets from the repo
  Stream<List<PetModel>> getUserPets() {
    final uid = _ref.read(userProvider)!.uid;
    return _petRepo.getUserPets(uid);
  }

  Stream<List<String>> getUserPetsNames() {
    final uid = _ref.read(userProvider)!.uid;
    return _petRepo.getUserPetsNames(uid);
  }

  Stream<PetModel> getPetByID(String petID) {
    return _petRepo.getPetByID(petID);
  }

  void setPet(PetModel pet, BuildContext context) async {
    final res = await _petRepo.setPet(pet);
    res.fold((l) => showSnackBar(context, l.message), (r) {});
  }

  void editPet({
    required File? avatarFile,
    required String name,
    required BuildContext context,
    required PetModel pet,
  }) async {
    state = true;
    if (avatarFile != null) {
      final res = await _storageRepo.storeFile(
          path: 'pets/petImage', id: pet.id!, file: avatarFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => pet = pet.copyWith(avatar: r));
    }
    pet = pet.copyWith(name: name);
    final res = await _petRepo.editPet(pet);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
