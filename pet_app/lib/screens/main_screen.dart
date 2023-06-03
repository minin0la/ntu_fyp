import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MainPage extends StatefulWidget {
  final String email;

  MainPage({required this.email});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      // appBar: AppBar(
      //   title: Text('Pet Companion App'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome back, ${widget.email}!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: _imageUrls.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      children: _imageUrls
                          .asMap()
                          .entries
                          .map((entry) => Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      entry.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Image ${entry.key + 1}',
                                    style: TextStyle(
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
      ),
    );
  }
}
