import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features_app/providers/user_places.dart';
import 'package:native_features_app/screens/add_place.dart';
import 'package:native_features_app/widgets/places_list.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
        backgroundColor: const Color.fromARGB(124, 76, 175, 162),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 142, 150, 0),
          title: const Text(
            'Selected Places',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()),
                );
              },
              icon: const Icon(Icons.add),
            )
          ], //list of widgets
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _placesFuture,
              builder: ((context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : PlacesList(places: userPlaces)),
            )));
  }
}

//futurebuilder is widget which takes future and builds widget 
// once it is resolved
// future being used here is the one yielded with load places