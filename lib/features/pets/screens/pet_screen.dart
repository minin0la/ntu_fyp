// ignore_for_file: public_member_api_docs, sort_constructors_first

import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/core/constants/constants.dart';
import 'package:pet_app/features/pets/controller/pet_controller.dart';
import 'package:pet_app/models/pet_model.dart';
import 'package:routemaster/routemaster.dart';

class PetScreen extends ConsumerWidget {
  final String petID;
  const PetScreen({
    super.key,
    required this.petID,
  });

  void setPet(pet, BuildContext context, WidgetRef ref) {
    ref.read(petControllerProvider.notifier).setPet(pet, context);
  }

  void navigateToEditPetScreen(BuildContext context, PetModel pet) {
    Routemaster.of(context).push('/edit-pets/${pet.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(userPetsProvider).when(
    //     data: (pet) => {
    //           print('pet'),
    //         },
    //     error: (err, stack) => Text(err.toString()),
    //     loading: () => const Loader());
    return Scaffold(
        body: ref.watch(getPetByIDProvider(petID)).when(
              data: (pet) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      pinned: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.network(
                            pet.avatar,
                            fit: BoxFit.cover,
                          ))
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(pet.name,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                OutlinedButton(
                                    onPressed: () =>
                                        navigateToEditPetScreen(context, pet),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25)),
                                    child: const Text("Edit"))
                              ],
                            ),
                          ],
                        )
                      ])),
                    )
                  ];
                },
                body: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 2,
                  children: [
                    // Text("TEST"),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: ref.watch(petRoutineProvider([
                            pet.lastbath,
                            Constants.lastbathThreshhold,
                            pet.name
                          ]))
                              ? Colors.red.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () => {
                          pet = pet.copyWith(lastbath: DateTime.now()),
                          setPet(pet, context, ref),
                          // ref.watch(petLoopProvider.notifier)
                          // .getPetsAttentionLoop(Duration.zero)
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bathtub_outlined,
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            const Text("Bath",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                "${DateTime.now().difference(pet.lastbath).inSeconds.toString()} hours ago",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: ref.watch(petRoutineProvider([
                            pet.lastfeeding,
                            Constants.lastfeedingThreshhold,
                            pet.name
                          ]))
                              ? Colors.red.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () => {
                          pet = pet.copyWith(lastfeeding: DateTime.now()),
                          setPet(pet, context, ref),
                          // ref.watch(petLoopProvider.notifier)
                          // .getPetsAttentionLoop(Duration.zero)
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.food_bank_outlined,
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            const Text("Food",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                "${DateTime.now().difference(pet.lastfeeding).inSeconds.toString()} hours ago",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: ref.watch(petRoutineProvider([
                            pet.lastwalk,
                            Constants.lastwalkingThreshhold,
                            pet.name
                          ]))
                              ? Colors.red.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () => {
                          pet = pet.copyWith(lastwalk: DateTime.now()),
                          setPet(pet, context, ref),
                          // ref.watch(petLoopProvider.notifier)
                          // .getPetsAttentionLoop(Duration.zero)
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.directions_walk_outlined,
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            const Text("Walk",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                "${DateTime.now().difference(pet.lastwalk).inSeconds.toString()} hours ago",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: ref.watch(petRoutineProvider([
                            pet.lastplaytime,
                            Constants.lastplaytimeThreshhold,
                            pet.name
                          ]))
                              ? Colors.red.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () => {
                          pet = pet.copyWith(lastplaytime: DateTime.now()),
                          setPet(pet, context, ref),
                          // ref.watch(petLoopProvider.notifier)
                          // .getPetsAttentionLoop(Duration.zero)
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sports_baseball_outlined,
                              size: 50,
                            ),
                            const SizedBox(height: 8),
                            const Text("Play",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                                "${DateTime.now().difference(pet.lastplaytime).inSeconds.toString()} hours ago",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              error: (err, stack) => Text(err.toString()),
              loading: () => const Loader(),
            ));
  }
}
