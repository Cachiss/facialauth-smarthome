import 'package:face_net_authentication/pages/widgets/cards/temperature.dart';
import 'package:face_net_authentication/pages/widgets/cards/toggle-led.dart';
import 'package:flutter/material.dart';

class Room extends StatefulWidget {
  const Room({Key? key, required this.sendCommand, required this.readCommand})
      : super(key: key);
  final Function sendCommand;
  final Function readCommand;

  turnOnLed() {
    sendCommand("led-prender");
  }

  turnOffLed() {
    sendCommand("led-apagar");
  }

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
            "https://blog.homedepot.com.mx/wp-content/uploads/2023/07/cuarto-organizado-1-1024x558.jpeg"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Living Room",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.center, child: TemperatureThermo()),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                children: [
                  ToggleLed(
                      title: "Habitacion",
                      ledOn: widget.turnOnLed,
                      ledOff: widget.turnOffLed),
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
