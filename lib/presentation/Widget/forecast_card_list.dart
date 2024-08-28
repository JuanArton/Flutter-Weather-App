import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForecastCard extends StatelessWidget {
  final Weather weather;

  const ForecastCard(this.weather);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final date = dateFormat.parse('${weather.date!.split(' ')[0]} ${weather.date!.split(' ')[1]}');
    final hourFormat = DateFormat('HH:mm');
    controller.loadFlutterAsset('assets/html/${weather.icon}.html');
    controller.setBackgroundColor(Colors.transparent);

    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 100,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${weather.temp?.floor()}°',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              textScaler: const TextScaler.linear(1.0),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: WebViewWidget(
                controller: controller,
              ),
            ),
            Text(
              hourFormat.format(date),
              textAlign: TextAlign.center,
              textScaler: const TextScaler.linear(1.0),
            ),
          ],
        ),
      ),
    );
  }
}
