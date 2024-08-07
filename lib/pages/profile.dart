import 'dart:convert';
import 'dart:io';
import 'dart:async'; // Importar la librería para usar Timer

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
  List<Widget> _widgetOptions = [];
  Timer? _connectTimeout; // Nuevo Timer para controlar el tiempo de espera

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

    _connectTimeout = Timer(Duration(seconds: 10), () {
      if (_connectedDevice == null) {
        FlutterBluePlus.stopScan();
        _showConnectError(
            'No se pudo conectar al dispositivo Bluetooth después de 10 segundos.');
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
              _connectTimeout?.cancel(); // Cancelar el Timer si se conecta
            });
            await _subscribeToNotifications(); // Llamar a _subscribeToNotifications aquí
            return;
          }
        }
      }
      _showConnectError('No se encontró una característica de escritura.');
    } catch (e) {
      print('Error de conexión: $e');
      _showConnectError('Error de conexión: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Room(sendCommand: _sendCommand, readCommand: _subscribeToNotifications),
      LivingRoom(sendCommand: _sendCommand),
      Kitchen(sendCommand: _sendCommand, readCommand: _readCommand),
    ];
  }

  void _showConnectError(String message) {
    setState(() {
      _connecting = false; // Finalizar el proceso de conexión
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de Conexión'),
          content: Text(message),
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
      try {
        String fullCommand = command + '\n';
        print('Enviando comando: $fullCommand');
        List<int> bytes = utf8.encode(fullCommand);
        await _characteristic!.write(bytes,
            withoutResponse: false); // Prueba sin `withoutResponse: true`
        print('Comando enviado');
      } catch (e) {
        print('Error al enviar comando: $e');
      }
    } else {
      print('No se puede enviar el comando, característica no inicializada');
    }
  }

  _readCommand() async {
    if (_characteristic != null) {
      var value = await _characteristic!.read();
      print('Valor leído: ${utf8.decode(value)}');
      return utf8.decode(value);
    } else {
      print('No se puede leer el valor');
    }
  }

  Future<void> _subscribeToNotifications() async {
    if (_characteristic != null) {
      try {
        await _characteristic!.setNotifyValue(true); // Habilitar notificaciones

        // Escuchar notificaciones
        _characteristic!.value.listen((value) {
          String decodedValue = utf8.decode(value);
          print('Notificación recibida: $decodedValue');
        });
      } catch (e) {
        print('Error al suscribirse a las notificaciones: $e');
      }
    } else {
      print(
          'No se puede suscribir a las notificaciones, característica no inicializada');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _connectTimeout?.cancel(); // Cancelar el Timer al desechar el widget
    super.dispose();
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
            if (_connectedDevice != null) // Mostrar solo si está conectado
              Container(
                child: _widgetOptions[_selectedIndex],
              ),
          ],
        ),
      ),
    );
  }
}
