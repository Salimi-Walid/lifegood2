import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String descreption = 'hay my name walid i need mony';
  bool ischangebg = false;
  final FlutterTts flutterTts = FlutterTts();
  Future _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.speak(descreption);
  }

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
            onTap: () => _speak(),
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
          Icon(Icons.more_vert, size: 28),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('titel', style: TextStyle(fontSize: 40)),
            Text('date', style: TextStyle(fontSize: 10)),
            SizedBox(height: 15),
            Text('Descreption', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
