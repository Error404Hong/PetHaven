import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/vendors/product_implementation.dart';

import '../../data/model/event.dart';
import '../../data/repository/customers/event_implementation.dart';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  int event = 0;
  int post = 0;
  Map<int, double> monthlyData = {};
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    getNumOfEvent();
    fetchData();
  }

  EventImplementation event_repo = EventImplementation();
  ProductImplementation product_repo = ProductImplementation();

  void getNumOfEvent() async {
    int ListOfEvent = await event_repo.getNumEvent();
    int listOfProduct = await product_repo.getNumProduct();
    setState(() {
      event = ListOfEvent;
      post = listOfProduct;
    });
  }

  void fetchData() async {
    Map<int, double> data = await product_repo.fetchMonthlyPayments();
    setState(() {
      monthlyData = data;
      print(monthlyData);
      isLoading = false; // Stop loading after fetching data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? Center(
        child: CircularProgressIndicator(), // Show loader while fetching
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "General",
            style: TextStyle(
              fontSize: 24, // Increased font size
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
          SizedBox(height: 20),
          BalanceCard(event: event, post: post),
          SizedBox(height: 20),
          const Text(
            "Monthly Revenue",
            style: TextStyle(
              fontSize: 24, // Increased font size
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
          SizedBox(height: 20),
          TransactionChart(monthlyData: monthlyData),
        ],
      ),
    );
  }
}
class BalanceCard extends StatelessWidget {
  final int event;
  final int post;

  const BalanceCard({super.key, required this.event, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard("Events", event, Icons.event, Colors.orange),
        _buildStatCard("Product", post, Icons.shop, Colors.blue),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return SizedBox(
      width: 180, // Fixed width
      height: 180, // Fixed height
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color), // Event/Post Icon
              const SizedBox(height: 10),
              Text(
                "$value",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class TransactionChart extends StatelessWidget {
  final Map<int, double> monthlyData;

  const TransactionChart({super.key, required this.monthlyData});

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
                  maxY: 4000,
                  barGroups: monthlyData.entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                            toY: entry.value,
                            color: Colors.blue,
                            width: 16
                        )
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          return Text(months[value.toInt() - 1]);
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