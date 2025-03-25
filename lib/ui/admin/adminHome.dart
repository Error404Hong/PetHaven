import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  int event = 0;
  int post = 0;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(

        children: [
          BalanceCard(Event: event, Post: post),
          SizedBox(height: 20),
          TransactionChart(),
        ],
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final int Event;
  final int Post;

  BalanceCard({required this.Event, required this.Post});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [

            SizedBox(
              height: 120,
              child:
              (Event == 0 && Post == 0)?
              Center(
                child: Text(
                  "No Posts and Events",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ):
            PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: Event.toDouble(),
                      color: Colors.orange,
                      title: 'Active',
                    ),
                    PieChartSectionData(
                      value: Post.toDouble(),
                      color: Colors.blue,
                      title: 'Inactive',
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Event", style: TextStyle(color: Colors.orange)),
                    Text("$Event", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text("Post", style: TextStyle(color: Colors.grey)),
                    Text("$Post", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class TransactionChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monthly Purchases",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 4000, // Adjust based on your data range
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2500, color: Colors.blue, width: 16)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 3000, color: Colors.blue, width: 16)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 2000, color: Colors.blue, width: 16)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3500, color: Colors.blue, width: 16)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 2800, color: Colors.blue, width: 16)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 2930, color: Colors.blue, width: 16)]),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 1:
                              return Text('Jan');
                            case 2:
                              return Text('Feb');
                            case 3:
                              return Text('Mar');
                            case 4:
                              return Text('Apr');
                            case 5:
                              return Text('May');
                            case 6:
                              return Text('Jun');
                            default:
                              return Text('');
                          }
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}