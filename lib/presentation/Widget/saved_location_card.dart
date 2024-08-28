import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/entities/weather.dart';

class SavedLocationCard extends StatelessWidget {
  final Weather weather;

  const SavedLocationCard(this.weather, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController();
    controller.loadFlutterAsset('assets/html/${weather.icon}.html');
    controller.setBackgroundColor(Colors.transparent);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weather.city ?? "Unkown",
                style: Theme.of(context).textTheme.titleLarge,
                textScaler: const TextScaler.linear(1.0),
              ),
              const SizedBox(height: 5.0,),
              Text(
                weather.weather ?? "Unkown",
                style: Theme.of(context).textTheme.titleSmall,
                textScaler: const TextScaler.linear(1.0),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "${weather.temp?.floor()}°",
                    style: Theme.of(context).textTheme.titleLarge,
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  const SizedBox(
                    width: 20,
                    height: 50,
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: WebViewWidget(
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
