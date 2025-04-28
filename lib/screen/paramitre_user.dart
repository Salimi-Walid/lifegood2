import 'package:flutter/material.dart';

class ParamitreUser extends StatefulWidget {
  const ParamitreUser({super.key});

  @override
  State<ParamitreUser> createState() => _ParamitreUserState();
}

class _ParamitreUserState extends State<ParamitreUser> {
  bool isswitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Switch(
          value: isswitched,
          onChanged: (value) {
            setState(() {
              isswitched = value;
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}
