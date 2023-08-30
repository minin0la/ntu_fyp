import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/constants/constants.dart';
import 'package:pet_app/core/utils.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/pets/repo/pet_repo.dart';
import 'package:pet_app/models/pet_model.dart';
import 'package:routemaster/routemaster.dart';

final userPetsProvider = StreamProvider((ref) {
  final petController = ref.watch(petControllerProvider.notifier);
  return petController.getUserPets();
});

final petControllerProvider = StateNotifierProvider<PetController, bool>((ref) {
  final petRepo = ref.watch(petRepoProvider);
  return PetController(petRepo: petRepo, ref: ref);
});

class PetController extends StateNotifier<bool> {
  final PetRepo _petRepo;
  final Ref _ref;
  PetController({
    required PetRepo petRepo,
    required Ref ref,
  })  : _petRepo = petRepo,
        _ref = ref,
        super(false);

  void addPet(
      // String petOwnerid,
      String petName,
      // String petType,
      // String petBreed,
      // int petAge,
      // int petWeight,
      // bool petVaccinated,
      // bool petNeutered,
      // bool petMicrochip,
      BuildContext context) async {
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
    );
    final res = await _petRepo.addPet(pet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), ((r) {
      Routemaster.of(context).pop();
    }));
  }

  // Stream the list of pets from the repo
  Stream<List<PetModel>> getUserPets() {
    final uid = _ref.read(userProvider)!.uid;
    return _petRepo.getUserPets(uid);
  }
}
