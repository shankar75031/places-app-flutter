import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:places_app/helpers/db_helper.dart';
import 'package:places_app/helpers/location_helper.dart';
import 'package:places_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image, PlaceLocation placeLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        placeLocation.latitude, placeLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: placeLocation.latitude,
      longitude: placeLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location.latitude,
        'loc_lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
    );
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
            ))
        .toList();
    notifyListeners();
  }

  Place findById(String placeId) {
    return _items.firstWhere((place) => place.id == placeId);
  }
}
