import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/pets/controller/pet_controller.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final petNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    petNameController.dispose();
  }

  void addPet() {
    ref
        .read(petControllerProvider.notifier)
        .addPet(petNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(petControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Pet Name"),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: petNameController,
                  decoration: const InputDecoration(
                      hintText: "Muffin",
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)),
                  maxLength: 20,
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: addPet,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "Add Pet",
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ]),
            ),
    );
  }
}
