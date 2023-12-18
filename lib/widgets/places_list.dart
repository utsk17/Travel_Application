import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:native_features_app/models/place.dart';
import 'package:native_features_app/screens/places_detail.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places have been added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    } //copywith is being used to override
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        /* for displaying the image*/
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(
              places[index].image), //to have image in background of circle
        ),
        title: Text(
          places[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Text(
          places[index].location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PlaceDetailScreen(
                  place: places[
                      index] //the index here gives what is passed to the place details screen
                  ),
            ),
          );
        },
      ),
    );
  }
}
