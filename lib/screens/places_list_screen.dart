import 'package:flutter/material.dart';
import 'package:places_app/providers/great_places.dart';
import 'package:places_app/screens/add_place_screen.dart';
import 'package:places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.ROUTE_NAME);
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future:
                Provider.of<GreatPlaces>(context, listen: false).fetchPlaces(),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<GreatPlaces>(
                    builder: (ctx, places, child) => places.items.length <= 0
                        ? child
                        : ListView.builder(
                            itemCount: places.items.length,
                            itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(places.items[i].image),
                              ),
                              title: Text(places.items[i].title),
                              subtitle: Text(places.items[i].location.address),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailsScreen.ROUTE_NAME,
                                  arguments: places.items[i].id,
                                );
                              },
                            ),
                          ),
                    child: Center(
                      child: Text('Got no places yet, start adding some!'),
                    ),
                  )),
      ),
    );
  }
}
