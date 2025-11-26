import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'dart:math';

import '../../providers/settings_provider.dart';

class GraphsScreen extends StatelessWidget {
  const GraphsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final chartData = provider.getChartData();

    final categoryExpenses = chartData['categoryExpenses'] as Map<String, double>;
    final totalExpense = chartData['totalExpense'] as double;
    final monthlySummary = chartData['monthlySummary'] as Map<String, Map<String, double>>;

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
              'Expense Breakdown by Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildPieChart(categoryExpenses, totalExpense),

            const SizedBox(height: 30),

            const Text(
              'Monthly Income vs Expense',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildBarChart(monthlySummary),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> categoryExpenses, double totalExpense) {
    if (categoryExpenses.isEmpty || totalExpense == 0) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No expense data available for the Pie Chart.')),
      );
    }

    final List<PieChartSectionData> pieSections = [];
    final List<Color> colorPalette = [
      Colors.red, Colors.blue, Colors.orange, Colors.purple, Colors.green,
      Colors.indigo, Colors.brown, Colors.teal
    ];
    int colorIndex = 0;

    categoryExpenses.forEach((category, amount) {
      final percentage = (amount / totalExpense) * 100;
      final color = colorPalette[colorIndex % colorPalette.length];
      colorIndex++;

      pieSections.add(
        PieChartSectionData(
          color: color,
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 80,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: pieSections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: categoryExpenses.entries.map((entry) {
            final color = colorPalette[categoryExpenses.keys.toList().indexOf(entry.key) % colorPalette.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, color: color),
                const SizedBox(width: 4),
                Text(entry.key, style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBarChart(Map<String, Map<String, double>> monthlySummary) {
    if (monthlySummary.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No transaction data available for the Bar Chart.')),
      );
    }

    final List<String> sortedMonths = monthlySummary.keys.toList();
    final List<String> lastSixMonths = sortedMonths.length > 6 ? sortedMonths.sublist(sortedMonths.length - 6) : sortedMonths;

    double maxAmount = 0;

    final List<BarChartGroupData> barGroups = lastSixMonths.asMap().entries.map((entry) {
      final index = entry.key;
      final monthKey = entry.value;
      final data = monthlySummary[monthKey]!;

      maxAmount = max(maxAmount, data['income'] ?? 0);
      maxAmount = max(maxAmount, data['expense'] ?? 0);

      return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data['income'] ?? 0,
              color: Colors.green,
              width: 8,
            ),
            BarChartRodData(
              toY: data['expense'] ?? 0,
              color: Colors.red,
              width: 8,
            ),
          ],
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxAmount * 1.1,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final monthIndex = value.toInt();
                  if (monthIndex >= 0 && monthIndex < lastSixMonths.length) {
                    final monthNumber = lastSixMonths[monthIndex].split('-')[1];
                    final monthAbbr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][int.parse(monthNumber) - 1];
                    return SideTitleWidget(
                      meta: meta,
                      space: 4,
                      child: Text(monthAbbr, style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text('₩${value.toInt()}', style: const TextStyle(fontSize: 10));
                    },
                    reservedSize: 30
                )
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true, horizontalInterval: maxAmount > 5000 ? maxAmount / 5 : 1000),
          barGroups: barGroups,
        ),
      ),
    );
  }
}