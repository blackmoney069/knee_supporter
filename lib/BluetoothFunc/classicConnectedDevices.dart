import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';

class BluetoothFunc extends StatefulWidget {
  const BluetoothFunc({Key? key}) : super(key: key);

  @override
  State<BluetoothFunc> createState() => _BluetoothFuncState();
}

class _BluetoothFuncState extends State<BluetoothFunc> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  List<BluetoothDevice> _devicesList = [];

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    Stream<BluetoothDiscoveryResult> discoveryResult =
    _bluetooth.startDiscovery();
    await for (final value in discoveryResult) {
      devices.add(value.device);
      print("Device added");
    }

    List<BluetoothDevice> bondedDevices = await _bluetooth.getBondedDevices();
    devices = devices + bondedDevices;


    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _bluetooth.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    // For retrieving the paired devices list
    getPairedDevices();
  }

  bool isDisconnecting = false;

  ListView _buildListViewOfDevices() {
    List<Padding> containers = [];
    for (BluetoothDevice device in _devicesList) {
      if (device.name == null) {
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
                          device.name == null
                              ? '(unknown device)'
                              : device.name as String,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          device.address,
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
                              backgroundColor:
                              MaterialStateProperty.all(Colors.green[300]),
                            ),
                            onPressed: ()async{
                              try{
                                await BluetoothConnection.toAddress(device.address);
                              } catch(e){
                                print("error in connection");
                              }
                            },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.green[300]),
                          ),
                          onPressed: () {},
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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: _buildListViewOfDevices(),
    );
  }
}
