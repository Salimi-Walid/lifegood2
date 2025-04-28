import 'package:flutter/material.dart';
import 'package:lifegood/model/container_notes.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 233, 165, 165),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Notes", style: TextStyle(color: Colors.black)),
        leading: Icon(Icons.sports_gymnastics),
      ),
      body: Column(children: [ContainerNotes()]),
    );
  }
}
