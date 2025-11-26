import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphsScreen extends StatelessWidget {
  GraphsScreen({super.key});

  final List<PieChartSectionData> pieChartSections = [
    PieChartSectionData(
      color: Colors.red,
      value: 40,
      title: 'Food (40%)',
      radius: 80,
    ),
    PieChartSectionData(
      color: Colors.blue,
      value: 30,
      title: 'Rent (30%)',
      radius: 80,
    ),
    PieChartSectionData(
      color: Colors.orange,
      value: 20,
      title: 'Shopping (20%)',
      radius: 80,
    ),
    PieChartSectionData(
      color: Colors.purple,
      value: 10,
      title: 'Other (10%)',
      radius: 80,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Graphs'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Monthly Expense Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: pieChartSections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Income vs Expense (Last 6 Months)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(

                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5000,
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 3500, color: Colors.green),
                      BarChartRodData(toY: 2800, color: Colors.red),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}