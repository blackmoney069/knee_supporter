import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeartChart extends StatefulWidget {
  const HeartChart({Key? key})
      : super(
          key: key,
        );

  @override
  State<HeartChart> createState() => _HeartChartState();
}

class _HeartChartState extends State<HeartChart> {
  List HeartArray = [];
  List _spots = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
        .doc("HeartRate")
        .get()
        .then((value) {
      HeartArray = List.from(value["array"]);
    });
  }



  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance.collection("users/WBICAL5j6hN7BiO18EDA/DailyData").doc("HeartRate").snapshots().listen((event) {
      setState(() {
        FirebaseFirestore.instance
            .collection("users/WBICAL5j6hN7BiO18EDA/DailyData")
            .doc("HeartRate")
            .get()
            .then((value) {
          HeartArray = List.from(value["array"]);
        });
      });
    })

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              "Heartbeat",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Silkscreen"),
            ),
            AspectRatio(
              aspectRatio: 2,
              child:
                  LineChart(LineChartData(minY: 60, maxY: 150, lineBarsData: [
                LineChartBarData(
                    dotData: FlDotData(show: false),
                    spots: HeartArray.asMap().entries.map((e) {
                      double index = e.key.toDouble();
                      double val = e.value.toDouble();
                      return FlSpot(index, val);
                    }).toList(),
                    isCurved: true)
              ])),
            ),
          ],
        ),
      ),
    );
  }
}
