import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/pages/Authentication/Login.dart';
import 'package:frontend/pages/Home/MyHomepage.dart';
import 'package:frontend/pages/Invoices/InvoicesPage.dart';

void main() {
  runApp(const MyApp());
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
        "/login": (context) => SafeArea(
            minimum: const EdgeInsets.fromLTRB(0, 20, 0, 0), child: LoginScreen()),
        "/home": (context) => const MyHomePage(title: "Gym Management"),
        "/invoices": (context) => InvoicesPage()
      },
    );
  }
}
