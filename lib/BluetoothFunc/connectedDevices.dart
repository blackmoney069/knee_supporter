import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectedDevices extends StatefulWidget {
  ConnectedDevices({Key? key}) : super(key: key);
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];

  @override
  State<ConnectedDevices> createState() => _ConnectedDevicesState();
}

class _ConnectedDevicesState extends State<ConnectedDevices> {
  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  ListView _buildListViewOfDevices() {
    List<Padding> containers = [];
    for (BluetoothDevice device in widget.devicesList) {
      if (device.name == "") {
        continue;
      } // filtering the devices with required names only
      containers.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          device.name == '' ? '(unknown device)' : device.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          device.id.toString(),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: TextButton(
                            child: Text(
                              'Connect',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green[300]),
                            ),
                            onPressed: () async {
                              widget.flutterBlue.stopScan();
                              try {
                                await device.connect();
                              } catch (e) {
                                rethrow;
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green[300]),
                          ),
                          onPressed: () async {
                            await device.disconnect();
                            print("Connection ended");
                          },
                          child: Text(
                            "Disconnect",
                            style: TextStyle(color: Colors.red[400]),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
            child: Text(
              "Choose a Device to connect",
              style: TextStyle(
                  fontFamily: "Silkscreen", fontSize: 15, color: Colors.white),
            ),
          ),
        ),
        ...containers,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: _buildListViewOfDevices(),
    );
  }
}
