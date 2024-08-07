import 'package:flutter/material.dart';

class ToggleDoor extends StatefulWidget {
  const ToggleDoor({Key? key, required this.title, required this.doorOpen})
      : super(key: key);
  final Function doorOpen;
  final String title;

  @override
  State<ToggleDoor> createState() => _ToggleDoorState();
}

class _ToggleDoorState extends State<ToggleDoor> {
  bool _doorState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Icons.door_front_door,
                  color: _doorState ? Colors.green : Colors.white,
                  size: 30,
                ),
                Switch(
                  value: _doorState,
                  onChanged: (bool value) async {
                    await widget.doorOpen();
                    setState(() {
                      _doorState = value;
                    });
                  },
                ),
              ]),
              Text(
                _doorState ? "Cerrar puerta" : "Abrir puerta",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "Puerta de ${widget.title}",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
