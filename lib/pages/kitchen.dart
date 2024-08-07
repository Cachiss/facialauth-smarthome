import 'package:flutter/material.dart';

class Kitchen extends StatefulWidget {
  const Kitchen(
      {Key? key, required this.sendCommand, required this.readCommand})
      : super(key: key);
  final Function sendCommand;
  final Function readCommand;
  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
