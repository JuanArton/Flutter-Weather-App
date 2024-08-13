import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/common/constants.dart';
import 'package:weatherapp/common/state_enum.dart';
import 'package:weatherapp/injection.dart' as di;
import 'package:weatherapp/presentation/pages/dashboardPage.dart';
import 'package:weatherapp/presentation/pages/settingsPage.dart';
import 'package:weatherapp/presentation/provider/forecast_notifier.dart';
import 'package:weatherapp/presentation/provider/location_notifier.dart';
import 'package:weatherapp/presentation/provider/weather_notifier.dart';
import 'package:weatherapp/presentation/util/location_handler.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.locator<WeatherNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<ForecastNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<LocationNotifier>(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            textTheme: kTextTheme,
          ),
          home: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0b0a26),
                    Color(0xFF333064),
                    Color(0xFF4b3793),
                    Color(0xFF7a4cb8)
                  ],
                  stops: [0.00, 0.25, 0.50, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: MyAppState(),
              ),
            ),
          ),
        )
    );
  }
}

class MyAppState extends StatefulWidget {
  const MyAppState({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppState> {
  int _selectedIndex = 0;
  bool? hasPermission;

  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    LocationHandler locationHandler = LocationHandler();
    bool permission = await locationHandler.handleLocationPermission();
    setState(() {
      hasPermission = permission;
    });

    Future.microtask(() {
      final locationNotifier = Provider.of<LocationNotifier>(context, listen: false);
      locationNotifier.fetchCurrentLocation();
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasPermission == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0b0a26),
                Color(0xFF333064),
                Color(0xFF4b3793),
                Color(0xFF7a4cb8)
              ],
              stops: [0.00, 0.25, 0.50, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Consumer<LocationNotifier>(
            builder: (context, data, child) {
              if (data.positionState == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.positionState == RequestState.Loaded) {
                if (data.position != null) {
                  LocationHandler().position = data.position;

                  return _pages[_selectedIndex];
                } else {
                  return const Center(
                    key: Key('error_message'),
                    child: Text("can't fetch location"),
                  );
                }

              } else {
                return Center(
                  key: const Key('error_message'),
                  child: Text(data.message),
                );
              }
            },
          )
      ),
    );
  }
}