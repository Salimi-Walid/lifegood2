import 'package:flutter/material.dart';
import 'dart:math';

class ContainerHobies extends StatefulWidget {
  final String? selection;
  final String date;
  final String titel;
  final String descreption;
  const ContainerHobies({
    super.key,
    required this.selection,
    required this.date,
    required this.titel,
    required this.descreption,
  });

  @override
  State<ContainerHobies> createState() => _ContainerHobiesState();
}

class _ContainerHobiesState extends State<ContainerHobies> {
  bool isdone = false;
  @override
  Widget build(BuildContext context) {
    List colors = [
      Color.fromARGB(255, 146, 233, 245),
      Color.fromARGB(255, 220, 245, 146),
      Color.fromARGB(255, 245, 187, 146),
      Color.fromARGB(255, 217, 170, 253),
    ];
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          color: colors[Random().nextInt(colors.length)],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 3,
              right: 10,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isdone = !isdone;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isdone
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Color.fromARGB(255, 26, 255, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    isdone
                        ? Icon(Icons.check, size: 20)
                        : Icon(Icons.add, size: 20),
                    isdone
                        ? Text("done", style: TextStyle(fontSize: 15))
                        : Text("I dowet", style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,

              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 0, 0),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.delete, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sports_soccer),
                          SizedBox(width: 8),
                          Text(
                            "${widget.selection}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Text(widget.date, style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Text(widget.titel, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text(widget.descreption),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
