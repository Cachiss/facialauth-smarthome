import 'dart:convert';
import 'dart:io';

import 'package:face_net_authentication/pages/kitchen.dart';
import 'package:face_net_authentication/pages/living-room.dart';
import 'package:face_net_authentication/pages/room.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Profile extends StatefulWidget {
  const Profile(this.username, {Key? key, required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  int _selectedIndex = 0;

  bool _connecting =
      false; // Nuevo estado para controlar el proceso de conexión

  void _connect() async {
    setState(() {
      _connecting = true; // Iniciar el proceso de conexión
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    var subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'BT04-A') {
          _connectToDevice(r.device);
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });

    await Future.delayed(Duration(seconds: 5));
    subscription.cancel();
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write) {
            setState(() {
              _connectedDevice = device;
              _characteristic = characteristic;
              _connecting = false; // Finalizar el proceso de conexión
            });
            return;
          }
        }
      }
      _showConnectError(); // Mostrar mensaje de error si no se encontró característica de escritura
    } catch (e) {
      print('Error de conexión: $e');
      _showConnectError(); // Mostrar mensaje de error si hubo una excepción al conectar
    }
  }

  void _showConnectError() {
    setState(() {
      _connecting = false; // Finalizar el proceso de conexión
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de Conexión'),
          content: Text('No se pudo conectar al dispositivo Bluetooth.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
            ),
          ],
        );
      },
    );
  }

  void _sendCommand(String command) async {
    if (_characteristic != null) {
      await _characteristic!.write(utf8.encode(command), withoutResponse: true);
      print('Comando enviado');
    } else {
      print('No se puede enviar el comando');
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Room(),
    LivingRoom(),
    Kitchen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121), // Establece el color de fondo aquí
      appBar: AppBar(
        title: Text('FaceNet Authentication',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF212121), // Establece el color de fondo aquí
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF212121), // Establece el color de fondo aquí
              ),
              child: Text('Casa inteligente',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Cuarto'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sala'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Cocina'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            AppButton(
              text: "Salir",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              color: Color(0xFFFF6161),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _connectedDevice != null
                      ? Icons.circle
                      : Icons.circle_outlined,
                  color: _connectedDevice != null ? Colors.green : Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  _connectedDevice != null ? 'Conectado' : 'Desconectado',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_connecting)
              CircularProgressIndicator() // Mostrar indicador de carga mientras se conecta
            else if (_connectedDevice == null)
              ElevatedButton.icon(
                onPressed: () {
                  _connect();
                },
                icon: Icon(Icons.bluetooth),
                label: Text('Conectar'),
              ),
            SizedBox(height: 20),
            Container(
              child: _widgetOptions[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
