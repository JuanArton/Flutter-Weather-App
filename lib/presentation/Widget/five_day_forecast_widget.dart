import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/presentation/Widget/day_card_list.dart';
import 'package:weatherapp/presentation/Widget/forecast_card_list.dart';
import 'package:weatherapp/presentation/provider/forecast_notifier.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/presentation/util/location_handler.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/weather.dart';

class FiveDayForecastWidget extends StatelessWidget {
  const FiveDayForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ForecastState(),
      ),
    );
  }
}

class ForecastState extends StatefulWidget {
  const ForecastState({super.key});

  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<ForecastState> {
  List<DateTime> uniqueDate = [];
  List<Weather> selectedDay = [];
  int selectedIndex = 0;

  final dayNumberFormat = DateFormat('d');
  final dayNameFormat = DateFormat('EEEE');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final forecastNotifier = Provider.of<ForecastNotifier>(context, listen: false);
      final position = LocationHandler().position;
      forecastNotifier.fetchWeatherForecast(position!.latitude, position.longitude).then((_) {
        final dtTxtList = forecastNotifier.weatherForecast?.map((it) => it.date).toList();

        final dateFormat = DateFormat('yyyy-MM-dd');
        for (final dtTxt in dtTxtList!) {
          final date = dateFormat.parse(dtTxt!.split(' ')[0]);

          if (!uniqueDate.contains(date)) {
            setState(() {
              uniqueDate.add(date);
            });
          }
        }

        filterWeatherList(dayNumberFormat.format(uniqueDate[0]), forecastNotifier.weatherForecast!);
      });
    });
  }

  void filterWeatherList(String date, List<Weather> weather) {
    selectedDay.clear();
    for (final i in weather) {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormat.parse(i.date!.split(' ')[0]);
      final dateNumber = dayNumberFormat.format(formattedDate);
      if (dateNumber == date ){
        setState(() {
          selectedDay.add(i);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Consumer<ForecastNotifier>(
          builder: (context, data, child) {
            if (data.weatherForecastState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.weatherForecastState == RequestState.Loaded) {
              return Column(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.black,
                    child: SizedBox(
                      height: 70.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: uniqueDate.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              filterWeatherList(
                                  dayNumberFormat.format(uniqueDate[index]), data.weatherForecast!
                              );
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: DayCard(
                              dayNumberFormat.format(uniqueDate[index]),
                              dayNameFormat.format(uniqueDate[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      "${dayNumberFormat.format(uniqueDate[selectedIndex])} ${dayNameFormat.format(uniqueDate[selectedIndex])}",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleLarge,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedDay.length,
                      itemBuilder: (context, index) {

                        final weather = selectedDay[index];
                        return ForecastCard(weather);
                      },
                    ),
                  ),
                ],
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
