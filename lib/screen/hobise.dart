import 'package:flutter/material.dart';
import 'package:lifegood/model/container_hobies.dart';

class Hobise extends StatefulWidget {
  const Hobise({super.key});

  @override
  State<Hobise> createState() => _HobiseState();
}

class _HobiseState extends State<Hobise> {
  bool isswitched = false;
  final TextEditingController _controllerTitel = TextEditingController();
  final TextEditingController _controllerDescreption = TextEditingController();
  void show_input_data() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Add your hobbies"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controllerTitel,
                      decoration: InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      controller: _controllerDescreption,
                      decoration: InputDecoration(hintText: 'Description'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Remind me"),
                        Switch(
                          value: isswitched,
                          onChanged: (value) {
                            setStateDialog(() {
                              isswitched = value;
                            });
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    isswitched ? Row(children: [Text('time')]) : Container(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      floatingActionButton: FloatingActionButton(
        onPressed: show_input_data,
        backgroundColor: Color.fromARGB(255, 255, 133, 133),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text("My Hobies", style: TextStyle(color: Colors.black)),
        leading: Icon(Icons.sports_gymnastics),
      ),
      body: Column(
        children: [
          ContainerHobies(
            titel: "Go the Sport",
            date: "12 jui",
            descreption: "12 jui i go to plau sport with friends",
            selection: "Sport",
          ),
          ContainerHobies(
            titel: "Go the Sport",
            date: "12 jui",
            descreption: "12 jui i go to plau sport with friends",
            selection: "Sport",
          ),
          ContainerHobies(
            titel: "Go the Sport",
            date: "12 jui",
            descreption: "12 jui i go to plau sport with friends",
            selection: "Sport",
          ),
        ],
      ),
    );
  }
}
