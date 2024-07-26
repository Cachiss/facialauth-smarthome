import 'package:flutter/material.dart';

class ToggleLed extends StatefulWidget {
  const ToggleLed({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<ToggleLed> createState() => _ToggleLedState();
}

class _ToggleLedState extends State<ToggleLed> {
  bool _ledState = false;

  @override
  Widget build(BuildContext context) {
    // card toggles the led state

    return Container(
      //width 50%
      width: MediaQuery.of(context).size.width * 0.45,
      child: Card(
        color: Color(0xFF2F2F2F),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Icon(
                  Icons.lightbulb,
                  color: _ledState ? Colors.yellow : Colors.white,
                  size: 30,
                ),
                Switch(
                  value: _ledState,
                  onChanged: (bool value) {
                    setState(() {
                      _ledState = value;
                    });
                  },
                ),
              ]),
              Text(
                "Luz de ${widget.title}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
