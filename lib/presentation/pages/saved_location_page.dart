import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/presentation/Widget/saved_location_card.dart';
import 'package:weatherapp/presentation/pages/new_location_page.dart';
import 'package:weatherapp/presentation/provider/saved_location_notifier.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/weather.dart';
import '../util/global_singleton.dart';


class SavedLocationPage extends StatelessWidget {
  const SavedLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: SavedLocationState()
      ),
    );
  }
}

class SavedLocationState extends StatefulWidget {
  const SavedLocationState({super.key});

  @override
  _SavedLocationState createState() => _SavedLocationState();
}

class _SavedLocationState extends State<SavedLocationState> {
  List<Weather>? weatherList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
        final savedLocationNotifier = Provider.of<SavedLocationNotifier>(context, listen: false);
        savedLocationNotifier.fetchSavedLocation();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0b0a26), Color(0xFF333064), Color(0xFF4b3793), Color(0xFF7a4cb8)],
            stops: [0.00, 0.25, 0.50, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<SavedLocationNotifier>(
          builder: (context, data, child) {
            if (data.listWeatherState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.listWeatherState == RequestState.Loaded) {
              if (data.listWeather.isEmpty) {
                return SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Data",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );

              } else {
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: data.listWeather.length,
                            itemBuilder: (context, index) {
                              final weather = data.listWeather[index];
                              return GestureDetector(
                                onTap: () {
                                  GlobalSingleton().newPosition = Position(
                                    latitude: weather.lat!,
                                    longitude: weather.lon!,
                                    timestamp: DateTime.now(),
                                    accuracy: 0.0,
                                    altitude: 0.0,
                                    heading: 0.0,
                                    speed: 0.0,
                                    speedAccuracy: 0.0,
                                    altitudeAccuracy: 0.0,
                                    headingAccuracy: 0.0,
                                  );
                                  BottomNavigationBar navigationBar = GlobalSingleton().glbKey.currentWidget as BottomNavigationBar;
                                  navigationBar.onTap!(0);
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: SavedLocationCard(weather),
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewLocationPage()),
          );

          Provider.of<SavedLocationNotifier>(context, listen: false)
          .fetchSavedLocation();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
