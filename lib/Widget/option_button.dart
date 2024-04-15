import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final double? size = 20;

  const OptionButton({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: ListTile(
        leading: Icon(
          icon,
          size: size,
        ),
        title: Text(name),
      ),
    );
  }
}
