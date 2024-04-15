import 'package:flutter/material.dart';
import 'package:medireminder/Views/HomePage/calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Column(
          children: [
            Calendar(),
          ],
        ),
      ),
    ));
  }
}
