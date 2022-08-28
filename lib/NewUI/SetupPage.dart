import 'dart:async';

import 'package:KneeSupporter/BackgroundCollectingTask.dart';
import 'package:KneeSupporter/ChatPage.dart';
import 'package:KneeSupporter/DiscoveryPage.dart';
import 'package:KneeSupporter/NewUI/BondedDeviceSelect.dart';
import 'package:KneeSupporter/NewUI/RecieveData.dart';
import 'package:KneeSupporter/SelectBondedDevicePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';


// import './helpers/LineChart.dart';

class SetupPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<SetupPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  Timer? _discoverableTimeoutTimer;

  BackgroundCollectingTask? _collectingTask;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
    });


    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(title: Center(child: const Text('Bluetooth Status', style: TextStyle(
                          fontFamily: "Silkscreen",color: Colors.green, fontSize: 20,
                        ),textAlign: TextAlign.center,))),
                        SwitchListTile(
                          title: const Text('Enable Bluetooth'),
                          value: _bluetoothState.isEnabled,
                          onChanged: (bool value) {
                            // Do the request and update with the true value then
                            future() async {
                              // async lambda seems to not working
                              if (value)
                                await FlutterBluetoothSerial.instance.requestEnable();
                              else
                                await FlutterBluetoothSerial.instance.requestDisable();
                            }

                            future().then((_) {
                              setState(() {});
                            });
                          },
                        ),
                        ListTile(
                          title: const Text('Bluetooth status'),
                          subtitle: Text(_bluetoothState.toString()),
                          trailing: ElevatedButton(
                            child: const Text('Settings'),
                            onPressed: () {
                              FlutterBluetoothSerial.instance.openSettings();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,20.0),

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(title: Center(child: const Text('Devices discovery and connection', style: TextStyle(
                          fontFamily: "Silkscreen",color: Colors.green, fontSize: 20,
                        ),textAlign: TextAlign.center,))),
                        ListTile(
                          title: ElevatedButton(
                              child: const Text('Explore discovered devices'),
                              onPressed: () async {
                                final BluetoothDevice? selectedDevice =
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DiscoveryPage();
                                    },
                                  ),
                                );

                                if (selectedDevice != null) {
                                  print('Discovery -> selected ' + selectedDevice.address);
                                } else {
                                  print('Discovery -> no device selected');
                                }
                              }),
                        ),
                        ListTile(
                          title: ElevatedButton(
                            child: const Text('Connect to paired device to chat'),
                            onPressed: () async {
                              final BluetoothDevice? selectedDevice =
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BondedDeviceSelect(checkAvailability: false);
                                  },
                                ),
                              );

                              if (selectedDevice != null) {
                                print('Connect -> selected ' + selectedDevice.address);
                                _startChat(context, selectedDevice);
                              } else {
                                print('Connect -> no device selected');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Made with ❤ at IIT Jammu", style: TextStyle(
                  color: Colors.black, shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 60.0,
                    color: Colors.green,
                  ),
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 60.0,
                    color: Colors.green,
                  ),
                ],
                ),),
              )

            ],
          ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return RecieveData(server: server);
        },
      ),
    );
  }
}
