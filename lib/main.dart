import 'package:flutter/material.dart';
import 'package:medireminder/Services/s_notification.dart';
import 'package:medireminder/Views/nav_tab.dart';
import 'package:medireminder/service_locator.dart';

Future<void> main() async {
  serviceLocatorInit();
  await serviceLocator.allReady();
  SNotification.initializeNotification();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NavTab(),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: NavTab(),
    ),
  );
}
