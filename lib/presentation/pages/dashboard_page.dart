import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/common/state_enum.dart';
import 'package:weatherapp/presentation/Widget/extra_info_widget.dart';
import 'package:weatherapp/presentation/provider/weather_notifier.dart';
import 'package:weatherapp/presentation/util/global_singleton.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Widget/five_day_forecast_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: WeatherInfoState()
      ),
    );
  }
}

class WeatherInfoState extends StatefulWidget {
  const WeatherInfoState({super.key});

  @override
  _WeatherInfoState createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfoState> {
  late final WebViewController _controller;
  var sunriseHour = "";
  var sunsetHour = "";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    Future.microtask(() {
          final weatherNotifier = Provider.of<WeatherNotifier>(context, listen: false);
          Position? position;
          if (GlobalSingleton().newPosition != null) {
            position = GlobalSingleton().newPosition;
            GlobalSingleton().position = GlobalSingleton().newPosition;
          } else {
            position = GlobalSingleton().position;
          }

          weatherNotifier.fetchCurrentWeather(position!.latitude, position.longitude).then((it) {
            final weather = weatherNotifier.currentWeather;

            if (weather != null) {
              final sunriseRaw = DateTime.fromMillisecondsSinceEpoch((weather.sunrise! ) * 1000, isUtc: true);
              DateTime sunrise = sunriseRaw.add(Duration(seconds: weather.timezone!));

              final sunsetRaw = DateTime.fromMillisecondsSinceEpoch((weather.sunset!) * 1000);
              DateTime sunset = sunsetRaw.add(Duration(seconds: weather.timezone!));

              sunriseHour = DateFormat("HH:mm").format(sunrise);
              sunsetHour = DateFormat("HH:mm").format(sunset);
            }
          });
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
        child: Consumer<WeatherNotifier>(
          builder: (context, data, child) {
            _controller.loadFlutterAsset('assets/html/${data.currentWeather?.icon}.html');
            _controller.setBackgroundColor(Colors.transparent);
            if (data.currentWeatherState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.currentWeatherState == RequestState.Loaded) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: WebViewWidget(
                          controller: _controller,
                        ),
                      ),
                      Text(
                        '${data.currentWeather?.city}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${data.currentWeather?.temp?.floor()}°',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'Feels like ${data.currentWeather?.feelsLike?.floor()}°',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${data.currentWeather?.weather}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: ExtraInfoWidget(
                                        "Sunrise", sunriseHour, 'assets/html/sunrise.html'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: ExtraInfoWidget(
                                        "Sunset", sunsetHour, "assets/html/sunset.html"
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: ExtraInfoWidget(
                                        "Humidity", "${data.currentWeather?.humidity}%", 'assets/html/humidity.html'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: ExtraInfoWidget(
                                          "Pressure", "${data.currentWeather?.pressure}mb", "assets/html/pressure.html"
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: const SizedBox(
                          height: 300,
                          child: FiveDayForecastWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

}
