import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

final mapRepoProvider = Provider<MapRepo>((ref) {
  return MapRepo();
});

class MapRepo {
  final _places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyAdAIFHBBzNyyB6-JzY5dQtOGiLcM9y25w'); // Replace with your actual API key

  Future<List<PlacesSearchResult>> searchPlaces(
      String query, LatLng location, String filter) async {
    final result = await _places.searchNearbyWithRankBy(
      Location(lat: location.latitude, lng: location.longitude),
      'distance',
      type: filter,
      keyword: query,
    );
    if (result.status == "OK") {
      return result.results;
    } else {
      throw Exception(result.errorMessage);
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }
}
