import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MainScreen extends StatefulWidget {
  final String email;

  MainScreen({required this.email});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('pets').listAll();

    final List<String> urls = [];
    for (final Reference ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    setState(() {
      _imageUrls = urls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
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
                            'Hello, Jasper!',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          Text(
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
                  SizedBox(
                    height: 25,
                  ),
                  // Pet Alert Alert
                  Row(
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
                  SizedBox(
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
                          padding: EdgeInsets.all(20),
                          child: Text("All set! Nothing to do here."),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(25.0),
              color: Colors.white,
              child: Center(
                  child: Column(
                children: [
                  // Pet heading
                  Row(
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
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  Expanded(
                      child: _imageUrls.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GridView.count(
                              crossAxisCount: 2,
                              children: _imageUrls
                                  .asMap()
                                  .entries
                                  .map((entry) => Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 70.0,
                                            backgroundImage: NetworkImage(
                                              entry.value,
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Pet ${entry.key + 1}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            )),
                ],
              )),
            )),
          ],
        ),
      ),
    );
  }
}
