import 'package:demo1/screens/add_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_palces.dart';
import '../widgets/places_list.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<PlacesScreen> createState() {
    // TODO: implement createState
    return _PlaceScreenState();
  }
}

class _PlaceScreenState extends ConsumerState<PlacesScreen> {
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
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircleAvatar())
                  : PlacesList(
                      places: userPlaces,
                    ),
        ),
      ),
    );
  }
}
