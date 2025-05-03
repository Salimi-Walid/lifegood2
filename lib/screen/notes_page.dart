import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  final String titel;
  final String date;
  final String descreption;
  final VoidCallback? ontapspeak;
  const NotesPage({
    super.key,
    required this.date,
    required this.descreption,
    required this.titel,
    required this.ontapspeak,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String descreption = 'hay my name walid i need mony';
  bool ischangebg = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 28),
        ),
        actions: [
          GestureDetector(
            onTap: widget.ontapspeak,
            child: Icon(Icons.play_arrow, size: 28),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                ischangebg = !ischangebg;
              });
            },
            child: Icon(Icons.photo_camera_back, size: 28),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titel,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.date,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              descreption,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
