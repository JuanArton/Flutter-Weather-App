import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/common/constants.dart';
import 'package:weatherapp/common/state_enum.dart';
import 'package:weatherapp/injection.dart' as di;
import 'package:weatherapp/presentation/pages/dashboard_page.dart';
import 'package:weatherapp/presentation/pages/new_location_page.dart';
import 'package:weatherapp/presentation/pages/saved_location_page.dart';
import 'package:weatherapp/presentation/provider/forecast_notifier.dart';
import 'package:weatherapp/presentation/provider/location_notifier.dart';
import 'package:weatherapp/presentation/provider/saved_location_notifier.dart';
import 'package:weatherapp/presentation/provider/weather_notifier.dart';
import 'package:weatherapp/presentation/util/global_singleton.dart';

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
          ChangeNotifierProvider(
              create: (_) => di.locator<SavedLocationNotifier>(),
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
    const SavedLocationPage(),
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
    GlobalSingleton locationHandler = GlobalSingleton();
    bool permission = await locationHandler.handleLocationPermission();
    setState(() {
      hasPermission = permission;
    });

    Future.microtask(() {
      final locationNotifier = Provider.of<LocationNotifier>(context, listen: false);
      locationNotifier.fetchCurrentLocation();
    });
    print('Position: Triggered again');
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
              Color(0xFF7a4cb8),
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
                GlobalSingleton().position = data.position;

                return _pages[_selectedIndex];
              } else {
                return const Center(
                  key: Key('error_message'),
                  child: Text("Can't fetch location"),
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
      bottomNavigationBar: BottomNavigationBar(
        key: GlobalSingleton().glbKey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Location',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF7a4cb8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
    );
  }
}