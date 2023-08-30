import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/core/common/error_text.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/pets/controller/pet_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

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
                          child: const Text("All set! Nothing to do here."),
                        ),
                      ),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Pets",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  //List of pets
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
                                return Column(
                                  children: [
                                    CircleAvatar(
                                      // subtitle: Text(pets[index].breed),
                                      // leading: CircleAvatar(
                                      backgroundImage: NetworkImage(pet.avatar),
                                      // ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(pet.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                );
                              },
                            ),
                          )),
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: (() => const Loader()))
                  // Expanded(
                  //     child: _imageUrls.isEmpty
                  //         ? const Center(
                  //             child: CircularProgressIndicator(),
                  //           )
                  //         : GridView.count(
                  //             crossAxisCount: 2,
                  //             children: _imageUrls
                  //                 .asMap()
                  //                 .entries
                  //                 .map((entry) => Column(
                  //                       children: [
                  //                         CircleAvatar(
                  //                           radius: 70.0,
                  //                           backgroundImage: NetworkImage(
                  //                             entry.value,
                  //                             // fit: BoxFit.cover,
                  //                           ),
                  //                         ),
                  //                         const SizedBox(height: 8),
                  //                         Text(
                  //                           'Pet ${entry.key + 1}',
                  //                           style: const TextStyle(
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                           textAlign: TextAlign.center,
                  //                         ),
                  //                       ],
                  //                     ))
                  //                 .toList(),
                  //           )),
                ],
              )),
            )),
          ],
        ),
      ),
    );
  }
}
