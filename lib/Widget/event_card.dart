import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medireminder/Models/med_event.dart';

class EventCard extends StatelessWidget {
  final MedEvent event;
  final Color color;
  EventCard({super.key, required this.event, this.color = Colors.grey});
  final f = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color.fromARGB(255, 91, 106, 192),
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Icon(
                    Icons.circle,
                    color: color,
                    size: 15,
                  ),
                ),
                Text(
                  f.format(event.time),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${event.dose} dose(s)   ${event.remarks}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
