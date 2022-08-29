import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:KneeSupporter/NewUI/DataPage.dart';
import 'package:KneeSupporter/NewUI/SetupPage.dart';
import 'package:KneeSupporter/NewUI/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class RecieveData2 extends StatefulWidget {
  final BluetoothDevice server;

  const RecieveData2({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class output {
  int CurrentBodyTemperature;
  int StepsSinceLastTransmission;
  int CurrentHeartbeat;
  int CaloriesSinceLastTransmission;

  output(this.CurrentBodyTemperature, this.StepsSinceLastTransmission,
      this.CurrentHeartbeat, this.CaloriesSinceLastTransmission);

  factory output.fromJson(dynamic json) {
    return output(
        json['CurrentBodyTemperature'] as int,
        json['StepsSinceLastTransmission'] as int,
        json['CurrentHeartbeat'] as int,
        json['CaloriesSinceLastTransmission'] as int);
  }
}

class _Message {
  late output text;
  int whom = 1;

  _Message(String input) {
    output _text = output.fromJson(jsonDecode(input));
    text = _text;
  }
}

class _ChatPage extends State<RecieveData2> {
  BluetoothConnection? connection;

  int StepsCounter = 0;
  int CaloriesCounter = 0;
  int bodyTemperature = 0;
  int heartbeat = 0;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  int _selectedIndex = 1;

  final screens = [
    SetupPage(),
    Text("Chat Page"),
    UserPage(),
  ];

  void _onClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serverName,
          style: TextStyle(fontFamily: "Silkscreen", color: Colors.green),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _selectedIndex == 1
          ? SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Calories",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: "Silkscreen"),
                                  ),
                                  Text(
                                    "${CaloriesCounter}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: "Silkscreen"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Steps",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: "Silkscreen"),
                                  ),
                                  Text(
                                    "${StepsCounter}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamily: "Silkscreen"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,20,0,0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Temp.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: "Silkscreen"),
                                    ),
                                    Text(
                                      "${bodyTemperature}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          fontFamily: "Silkscreen"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "HeartRate",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: "Silkscreen"),
                                    ),
                                    Text(
                                      "${heartbeat}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          fontFamily: "Silkscreen"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
                        child: Text(
                          isConnecting
                              ? "Wait until Connected"
                              : isConnected
                                  ? "Connected"
                                  : "Chat got disconnected",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : screens[_selectedIndex],
      bottomNavigationBar:
          BottomNavigationBar(currentIndex: 1, onTap: _onClick, items: [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup"),
        BottomNavigationBarItem(
            icon: Icon(Icons.data_saver_off_rounded), label: "Data"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
      ]),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(_Message(
          backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        ));
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    CaloriesCounter += messages[0].text.CaloriesSinceLastTransmission;
    StepsCounter += messages[0].text.StepsSinceLastTransmission;
    bodyTemperature = messages[0].text.CurrentBodyTemperature;
    heartbeat = messages[0].text.CurrentHeartbeat;
  }
}
