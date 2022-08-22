import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class NotEnabled extends StatelessWidget {
  const NotEnabled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Bluetooth not enabled',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Silkscreen"
            ),),

            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please enable Bluetooth',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Silkscreen"
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: AppSettings.openBluetoothSettings,
                        icon:Icon(Icons.settings_bluetooth_rounded, size: 25,),
                        label: Text('Turn on Bluetooth', style: TextStyle(fontSize: 18),),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(8),
                          primary: Colors.blue[300]
                        )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}
