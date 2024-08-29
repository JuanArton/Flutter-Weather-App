import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Define your custom widget
class ExtraInfoWidget extends StatelessWidget {
  final String title;
  final String value;
  final String image;

  const ExtraInfoWidget(this.title, this.value, this.image);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController();
    controller.loadFlutterAsset(image);
    controller.setBackgroundColor(Colors.transparent);

    return Container(
      padding: const EdgeInsets.all(16.0),
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
                title,
                style: Theme.of(context).textTheme.titleSmall,
                textScaler: const TextScaler.linear(1.0),
              ),
              const SizedBox(height: 5.0,),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge,
                textScaler: const TextScaler.linear(1.0),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
    );
  }
}
