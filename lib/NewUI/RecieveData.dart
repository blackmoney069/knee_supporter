import 'dart:convert';
import 'dart:typed_data';

import 'package:KneeSupporter/NewUI/SetupPage.dart';
import 'package:KneeSupporter/NewUI/UserPage.dart';
import 'package:KneeSupporter/Widgets/GraphWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibration/vibration.dart';

class RecieveData extends StatefulWidget {
  final BluetoothDevice server;

  const RecieveData({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class output {
  int CurrentBodyTemperature;
  int StepsSinceLastTransmission;
  int CurrentHeartbeat;
  int CaloriesSinceLastTransmission;
  int CurrentHumidity;

  output(
      this.CurrentBodyTemperature,
      this.StepsSinceLastTransmission,
      this.CurrentHeartbeat,
      this.CaloriesSinceLastTransmission,
      this.CurrentHumidity);

  factory output.fromJson(dynamic json) {
    return output(
        json['CurrentBodyTemperature'].toInt(),
        json['StepsSinceLastTransmission'].toInt(),
        json['CurrentHeartbeat'],
        json['CaloriesSinceLastTransmission'],
        json['CurrentBodyHumidity'].toInt());
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

class _ChatPage extends State<RecieveData> {
  BluetoothConnection? connection;

  int StepsCounter = 0;
  int CaloriesCounter = 0;
  int CurrentHumidity = 0;
  int CurrentBodyTemperature = 0;
  int CurrentHeartbeat = 0;

  _Message? LastMessage;
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

  void Alert() {
    HapticFeedback.heavyImpact();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Health is critical"),
              content: Text("Heartrate is unusual"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ],
            ));
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
    FirebaseFirestore.instance
        .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
        .doc("Humidity")
        .update({"array": []});
    FirebaseFirestore.instance
        .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
        .doc("HeartRate")
        .update({"array": []});
    FirebaseFirestore.instance
        .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
        .doc("Steps")
        .update({"TotalSteps": 0});
    FirebaseFirestore.instance
        .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
        .doc("Temperature")
        .update({"array": []});
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
                        padding: const EdgeInsets.fromLTRB(0.0, 20, 0, 0),
                        child: Row(
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
                                      "Temperature",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          fontFamily: "Silkscreen"),
                                    ),
                                    Text(
                                      "${CurrentBodyTemperature} C",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,),
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
                                      "Rel. Humidity",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          fontFamily: "Silkscreen"),
                                    ),
                                    Text(
                                      "${CurrentHumidity}%",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      HeartChart()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
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
        final _Message _mes = _Message(
          backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        );
        LastMessage = _mes;
        CaloriesCounter += LastMessage!.text.CaloriesSinceLastTransmission==null?0:LastMessage!.text.CaloriesSinceLastTransmission;
        StepsCounter += LastMessage!.text.StepsSinceLastTransmission;
        CurrentBodyTemperature = LastMessage!.text.CurrentBodyTemperature;
        CurrentHeartbeat = LastMessage!.text.CurrentHeartbeat;
        if(CurrentHeartbeat>100){
          Alert();
        }
        if(CurrentBodyTemperature>40){
          Alert();
        }
        // calls to the firebase store to keep data
        FirebaseFirestore.instance
            .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
            .doc("Humidity")
            .get()
            .then((value) {
          List HumidArray = List.from(value["array"]);
          HumidArray.add(CurrentHumidity);
          FirebaseFirestore.instance
              .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
              .doc("Humidity")
              .update({"array": HumidArray});
        });
        FirebaseFirestore.instance
            .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
            .doc("HeartRate")
            .get()
            .then((value) {
          List HeartArray = List.from(value["array"]);
          HeartArray.add(CurrentHeartbeat);
          FirebaseFirestore.instance
              .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
              .doc("HeartRate")
              .update({"array": HeartArray});
        });
        FirebaseFirestore.instance
            .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
            .doc("Temperature")
            .get()
            .then((value) {
          List TempArray = List.from(value["array"]);
          TempArray.add(CurrentBodyTemperature);
          FirebaseFirestore.instance
              .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
              .doc("Temperature")
              .update({"array": TempArray});
        });

        FirebaseFirestore.instance
            .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
            .doc("Steps")
            .update({
          "TotalSteps":
              FieldValue.increment(LastMessage!.text.StepsSinceLastTransmission)
        });

        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}
