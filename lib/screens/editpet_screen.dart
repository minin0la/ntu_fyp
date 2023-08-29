import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/models/pet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create new provider that retrive data from firebase

class EditPetScreen extends StatefulWidget {
  const EditPetScreen({super.key});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SingleChildScrollView(
                child: Column(
              children: [
                const Text("Your Pets"),
                TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "pets": FieldValue.arrayUnion([
                          PetModel(
                                  petName: "TEST ${Random().nextInt(10)}",
                                  petType: "TEST",
                                  petBreed: "TEST",
                                  petAge: 12,
                                  petWeight: 12,
                                  petVaccinated: true,
                                  petNeutered: true,
                                  petMicrochip: true,
                                  petBirthDate: DateTime.now(),
                                  petLastCheckup: DateTime.now(),
                                  petLastGrooming: DateTime.now())
                              .toJson()
                        ])
                      });
                    },
                    child: const Text("Add new pet")),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final snap = snapshot.data!;
                        return Column(
                          children: [
                            Text("Your email is ${snap['email']}"),
                          ],
                        );
                      } else {
                        return const Text("No data");
                      }
                    })
              ],
            )),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.toString().contains("pets")) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!["pets"].length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                    snapshot.data!["pets"][index]["petName"]),
                                subtitle: Text(
                                    snapshot.data!["pets"][index]["petType"]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPetScreen()));
                                  },
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Text("No data");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
