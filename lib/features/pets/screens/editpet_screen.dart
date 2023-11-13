import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/common/error_text.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/core/constants/constants.dart';
import 'package:pet_app/core/utils.dart';
import 'package:pet_app/features/pets/controller/pet_controller.dart';
import 'package:pet_app/models/pet_model.dart';

class EditPetScreen extends ConsumerStatefulWidget {
  final String petID;
  const EditPetScreen({super.key, required this.petID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPetScreenState();
}

void deletePet(WidgetRef ref, BuildContext context, PetModel pet) async {
  ref.read(petControllerProvider.notifier).deletePet(pet, context);
}

class _EditPetScreenState extends ConsumerState<EditPetScreen> {
  File? avatarFile;
  late TextEditingController _petNameController;
  PetModel? pet;
  void selectPetImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        avatarFile = File(res.files.first.path!);
      });
    }
  }

  void save(PetModel pet) {
    ref.read(petControllerProvider.notifier).editPet(
        pet: pet,
        avatarFile: avatarFile,
        context: context,
        name: _petNameController.text);
  }

  @override
  void initState() {
    super.initState();
    _petNameController = TextEditingController(
        text: ref.read(getPetByIDProvider(widget.petID)).value!.name);
  }

  @override
  void dispose() {
    _petNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(petControllerProvider);
    return ref.watch(getPetByIDProvider(widget.petID)).when(
        data: (pet) => Scaffold(
              // backgroundColor: Palla.,
              appBar: AppBar(
                title: const Text("Edit Pet"),
                centerTitle: false,
                actions: [
                  TextButton(onPressed: () {}, child: const Text("Save"))
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Column(children: [
                      GestureDetector(
                        onTap: selectPetImage,
                        child: DottedBorder(
                            child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: avatarFile != null
                              ? Image.file(avatarFile!)
                              : pet.avatar.isEmpty ||
                                      pet.avatar == Constants.avatarDefault
                                  ? const Center(
                                      child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ))
                                  : Image.network(
                                      pet.avatar,
                                      fit: BoxFit.cover,
                                    ),
                        )),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _petNameController,
                        decoration: const InputDecoration(
                            labelText: "Pet Name",
                            border: OutlineInputBorder()),
                      ),
                      OutlinedButton(
                          onPressed: () => save(pet),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25)),
                          child: const Text("Save")),
                      OutlinedButton(
                          onPressed: () => deletePet(ref, context, pet),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25)),
                          child: const Text("Delete")),
                    ]),
            ),
        loading: () => const Loader(),
        error: (error, stack) => ErrorText(error: error.toString()));
  }
}
