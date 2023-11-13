import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pet_app/features/maps/controller/map_controller.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(1.290270, 103.851959);
    tappedPlacedDetail = {};
  }

  @override
  void dispose() {
    super.dispose();
  }

  var tappedPlacedDetail;
  LatLng currentLocation =
      LatLng(1.290270, 103.851959); // Initial location coordinates

  String selectedFilter = 'veterinary_care'; // Default filter

  bool showOpenNowOnly = true; // Keep track of whether to show open now only

  Future<void> updateListView(MapController mapController) async {
    Position position = await mapController.getUserCurrentLocation();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    List<PlacesSearchResult> results =
        await mapController.searchPlaces('', currentLocation, selectedFilter);

    if (showOpenNowOnly) {
      results = results
          .where((place) => place.openingHours?.openNow ?? false)
          .toList();
    }

    setState(() {
      ref.read(mapPlacesProvider.notifier).update((state) => results);
    });
  }

  Future<Map<String, dynamic>> getPlace(String? input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=AIzaSyAdAIFHBBzNyyB6-JzY5dQtOGiLcM9y25w';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final mapController = ref.read(mapControllerProvider.notifier);
    final mapPlaces = ref.watch(mapPlacesProvider);
    final mapSearch = ref.watch(mapsearchProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby'),
        actions: [
          // DropdownButton<String>(
          //   value: selectedFilter,
          //   onChanged: (String? newValue) {
          //     setState(() {
          //       selectedFilter = newValue!;
          //     });
          //   },
          //   items: <String>['veterinary_care', 'pet_store', 'dog_park']
          //       .map<DropdownMenuItem<String>>((String value) {
          //     String label;
          //     if (value == 'veterinary_care') {
          //       label = 'Veterinary Care';
          //     } else if (value == 'pet_store') {
          //       label = 'Pet Store';
          //     } else if (value == 'dog_park') {
          //       label = 'Dog Park';
          //     } else {
          //       label = value;
          //     }
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(label),
          //     );
          //   }).toList(),
          // ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              Position position = await mapController.getUserCurrentLocation();
              setState(() {
                currentLocation = LatLng(position.latitude, position.longitude);
              });
              updateListView(mapController);
            },
          ),
        ],
      ),
      body: mapPlaces == []
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 135),
              Image.asset(
                "assets/login_pet.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 30),
              Text('Refresh to load nearby places',
                  style: GoogleFonts.getFont(
                    'Dancing Script',
                    textStyle: const TextStyle(
                      fontSize: 46,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ])
          : StreamBuilder<List<PlacesSearchResult>>(
              stream: Stream.value(mapPlaces), // Example location coordinates
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data!.length == 0) {
                    updateListView(mapController);
                  }
                  // if (snapshot.data == []) {
                  //   updateListView(mapController);
                  // }
                  List<PlacesSearchResult> _placesList = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _placesList.length,
                          itemBuilder: (context, index) {
                            final place = _placesList[index];
                            final bool isOpenNow =
                                place.openingHours?.openNow ?? false;
                            return ListTile(
                              title: Text('${place.name}'),
                              subtitle: Row(
                                children: [
                                  Text(
                                    isOpenNow ? 'Open Now' : 'Closed',
                                    style: TextStyle(
                                      color:
                                          isOpenNow ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some space between the title and "Open Now"
                                  Expanded(
                                    // Added Expanded widget here
                                    child: Text(
                                      // Wrapped Text widget with Expanded
                                      place.vicinity!,
                                      overflow: TextOverflow
                                          .ellipsis, // Added this line to handle long text
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () async {
                                  print(place.placeId);
                                  tappedPlacedDetail =
                                      await getPlace(place.placeId);
                                  setState(() {});
                                  openDetailsScreen(context, place);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Select Filter'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFilter = newValue!;
                            });
                          },
                          items: <String>[
                            'veterinary_care',
                            'pet_store',
                            // 'dog_park'
                          ].map<DropdownMenuItem<String>>((String value) {
                            String label;
                            if (value == 'veterinary_care') {
                              label = 'Veterinary Care';
                            } else if (value == 'pet_store') {
                              label = 'Pet Store';
                            } else {
                              label = value;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(label),
                            );
                          }).toList(),
                        ),
                        CheckboxListTile(
                          title: Text('Open Now Only'),
                          value: showOpenNowOnly,
                          onChanged: (bool? value) {
                            setState(() {
                              showOpenNowOnly = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          updateListView(
                              mapController); // Call updateListView after selecting options
                          Navigator.pop(context);
                        },
                        child: Text('Apply'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }

  void openDetailsScreen(BuildContext context, PlacesSearchResult place) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(place.name ?? ''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (place.photos != null && place.photos!.isNotEmpty)
                Image.network(
                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${place.photos![0].photoReference!}&key=AIzaSyAdAIFHBBzNyyB6-JzY5dQtOGiLcM9y25w',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              Text('Address: ${tappedPlacedDetail["formatted_address"]}'),
              Text(
                  'Operating Hours: ${place.openingHours?.weekdayText?.join(', ') ?? ''}'),
              Text('Rating: ${place.rating ?? ''}'),
              // Text('Website: ${place. ?? ''}'),
              Text(
                  'Phone Number: ${tappedPlacedDetail["formatted_phone_number"] ?? ''}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
