import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class editPetPage extends StatefulWidget {
  const editPetPage({super.key});

  @override
  State<editPetPage> createState() => _editPetPageState();
}

class _editPetPageState extends State<editPetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Text("Edit Pets"),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("pets").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  print(snap);
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return Text(snap[index]['Name']);
                      });
                }
                return Text("No widget to build");
              }),
        ],
      )),
    );
  }
}
