import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/presentation/provider/saved_location_notifier.dart';


class NewLocationPage extends StatefulWidget {
  static const ROUTE_NAME = '/settings';

  const NewLocationPage({super.key});

  @override
  _NewLocationPageState createState() => _NewLocationPageState();
}

class _NewLocationPageState extends State<NewLocationPage> {
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
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: FlutterLocationPicker(
                  initZoom: 11,
                  minZoomLevel: 1,
                  maxZoomLevel: 24,
                  trackMyPosition: true,
                  searchBarTextColor: Colors.black,
                  selectLocationButtonText: 'Add Location',
                  onPicked: (pickedData) async {
                    await Provider.of<SavedLocationNotifier>(
                      context,
                      listen: false
                    )
                    .addLocation(
                        pickedData.latLong.latitude,
                        pickedData.latLong.longitude
                    );

                    final message = Provider.of<SavedLocationNotifier>(
                      context,
                      listen: false
                    )
                    .message;

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)));

                    Navigator.pop(context);
                  },
                  onError: (error) {
                    print('Error: $error');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
