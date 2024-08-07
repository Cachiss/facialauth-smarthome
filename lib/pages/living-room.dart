import 'package:face_net_authentication/pages/widgets/cards/open-door.dart';
import 'package:face_net_authentication/pages/widgets/cards/temperature.dart';
import 'package:flutter/material.dart';

class LivingRoom extends StatefulWidget {
  const LivingRoom({Key? key, required this.sendCommand}) : super(key: key);
  final Function sendCommand;

  @override
  State<LivingRoom> createState() => _LivingRoomState();
}

class _LivingRoomState extends State<LivingRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
            "http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRzpCShCMaoY_XOsN7pk1w2FFHUNXHda69z_m01NVNCvADzZHjONlGrXP2TVS7jymSRatNI6tJPXK8OED18yKk"),
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
              ToggleDoor(
                title: "Sala",
                doorOpen: () async {
                  widget.sendCommand("puerta");
                },
              )
            ],
          ),
        ),
      ],
    ));
  }
}
