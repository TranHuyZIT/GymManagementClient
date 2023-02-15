import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/pages/Authentication/Login.dart';
import 'package:frontend/pages/MyHomepage.dart';

void main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "BeVietnamPro"),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const Login(),
        "/home": (context) => const MyHomePage(title: "Gym Management")
      },
    );
  }
}
