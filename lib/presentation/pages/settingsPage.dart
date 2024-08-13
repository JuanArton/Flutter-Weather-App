import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const ROUTE_NAME = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.blue),
        child: const Icon(
          Icons.camera,
          size: 70,
        ),
      ),
    );
  }
}