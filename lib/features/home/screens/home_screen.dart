import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/common/error_text.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/pets/controller/pet_controller.dart';
import 'package:pet_app/models/pet_model.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void navigateToPetScreen(BuildContext context, PetModel pet) {
    Routemaster.of(context).push('/pets/${pet.id}');
  }

  void navigateToAddPetScreen(BuildContext context) {
    Routemaster.of(context).push('/add-pet');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final refreshPets = ref.watch(petAttentionProvider);
    // final refreshNotification = ref.watch(petNotificationProvider);
    // print(refreshPets);

    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user?.firstname} ${user?.lastname}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Good Morning',
                            style: TextStyle(
                              // fontSize: 10,
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Pet Alert Alert
                  const Row(
                    children: [
                      Text(
                        'Overview',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: refreshPets.isEmpty
                                ? const Text(
                                    'All good!',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                : Text(
                                    '${refreshPets.map((pet) => pet.name).join(", ")} needs your attention',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                      )

                      // ref.watch(petLoopProvider).when(
                      //     data: ((pets) => Expanded(
                      //           child: Container(
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius: BorderRadius.circular(12),
                      //               ),
                      //               padding: const EdgeInsets.all(20),
                      //               child: pets == null
                      //                   ? const Text(
                      //                       'All good!',
                      //                       style: TextStyle(
                      //                           fontSize: 18,
                      //                           fontWeight: FontWeight.bold,
                      //                           color: Colors.black),
                      //                     )
                      //                   : Text(
                      //                       '${pets.map((pet) => pet.name).join(", ")} needs your attention',
                      //                       style: const TextStyle(
                      //                           fontSize: 18,
                      //                           fontWeight: FontWeight.bold,
                      //                           color: Colors.black),
                      //                     )),
                      //         )),
                      //     error: (error, stackTrace) =>
                      //         ErrorText(error: error.toString()),
                      //     loading: (() => const Loader()))
                      // Text(pets.value[0].name.toString())
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(25.0),
              color: Colors.white,
              child: Center(
                  child: Column(
                children: [
                  // Pet heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Pets',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                      OutlinedButton(
                          onPressed: () => navigateToAddPetScreen(context),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25)),
                          child: const Text("Add Pet"))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  ref.watch(userPetsProvider).when(
                      data: ((pets) => Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: pets.length,
                              itemBuilder: (context, index) {
                                final pet = pets[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: refreshPets
                                              .map((pet) => pet.name)
                                              .toList()
                                              .contains(pet.name)
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.green.withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: InkWell(
                                    onTap: () {
                                      navigateToPetScreen(context, pet);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          // subtitle: Text(pets[index].breed),
                                          // leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(pet.avatar),
                                          // ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(pet.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                      error: (error, stackTrace) => const ErrorText(error: ''),
                      loading: (() => const Loader()))
                ],
              )),
            )),
          ],
        ),
      ),
    );
  }
}
