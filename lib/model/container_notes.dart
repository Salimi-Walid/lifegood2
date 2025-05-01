import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lifegood/screen/notes_page.dart';

class ContainerNotes extends StatelessWidget {
  final String titel;
  final String descreption;
  final String date;
  const ContainerNotes({
    super.key,
    required this.date,
    required this.descreption,
    required this.titel,
  });

  @override
  Widget build(BuildContext context) {
    List colors = [
      Color.fromARGB(255, 158, 186, 234),
      Color.fromARGB(255, 169, 234, 158),
      Color.fromARGB(255, 245, 169, 148),
      Color.fromARGB(255, 234, 158, 209),
      Color.fromARGB(255, 193, 244, 90),
    ];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesPage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors[Random().nextInt(colors.length)],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titel,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  descreption,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  date,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
