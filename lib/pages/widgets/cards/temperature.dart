import 'package:flutter/material.dart';

class TemperatureThermo extends StatefulWidget {
  const TemperatureThermo({Key? key}) : super(key: key);

  @override
  State<TemperatureThermo> createState() => _TemperatureThermoState();
}

class _TemperatureThermoState extends State<TemperatureThermo> {
  double _temperature = 35;
  @override
  Widget build(BuildContext context) {
    // circular progress bar for temperature
    return Container(
      child: Column(
        children: [
          Text(
            "Temperatura",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _temperature / 50,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 249, 220, 0)),
                  backgroundColor: Colors.white,
                  strokeWidth: 10,
                ),
              ),
              Positioned(
                top: 80,
                left: 80,
                child: Text(
                  "$_temperature°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
