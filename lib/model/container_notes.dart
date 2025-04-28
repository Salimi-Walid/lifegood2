import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lifegood/screen/notes_page.dart';

class ContainerNotes extends StatelessWidget {
  const ContainerNotes({super.key});

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
                Text("Titel", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("Descreption", style: TextStyle(fontSize: 15)),
                SizedBox(height: 10),
                Text("Date 20 jui 2025", style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
