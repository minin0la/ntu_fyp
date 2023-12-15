import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pet_app/features/maps/repo/map_repo.dart';

final mapProvider = StateProvider<MapController?>((ref) => null);

final mapControllerProvider = StateNotifierProvider<MapController, bool>((ref) {
  final mapRepo = ref.watch(mapRepoProvider);
  return MapController(ref: ref, mapRepo: mapRepo);
});

final mapsearchProvider =
    StateProvider<Future<List<PlacesSearchResult>>>((ref) {
  final mapController = ref.watch(mapControllerProvider.notifier);
  return mapController.searchPlaces('', const LatLng(1.290270, 103.851959), '');
});

final mapPlacesProvider = StateProvider<List<PlacesSearchResult>>((ref) {
  List<PlacesSearchResult> result = [];
  return result;
});

class MapController extends StateNotifier<bool> {
  final MapRepo _mapRepo;
  final Ref _ref;
  MapController({required MapRepo mapRepo, required Ref ref})
      : _mapRepo = mapRepo,
        _ref = ref,
        super(false);

  Future<List<PlacesSearchResult>> searchPlaces(
      String query, LatLng location, String filter) {
    return _mapRepo.searchPlaces(query, location, filter);
  }

  Future<Position> getUserCurrentLocation() async {
    return _mapRepo.getUserCurrentLocation();
  }
}
