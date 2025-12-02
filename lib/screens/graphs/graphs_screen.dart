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
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final chartData = transactionProvider.getChartData(context);
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;
    final colorScheme = Theme.of(context).colorScheme;

    final categoryExpenses = chartData['categoryExpenses'] as Map<String, double>;
    final totalExpense = chartData['totalExpense'] as double;
    final monthlySummary = chartData['monthlySummary'] as Map<String, Map<String, double>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Graphs'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildGraphCard(
              context,
              colorScheme,
              title: 'Expense Breakdown by Category',
              chartWidget: _buildPieChart(context, categoryExpenses, totalExpense),
              legendWidget: _buildPieChartLegend(context, categoryExpenses),
              noDataMessage: 'No expense data available for the Pie Chart.',
            ),

            const SizedBox(height: 25),

            _buildGraphCard(
              context,
              colorScheme,
              title: 'Monthly Income vs Expense',
              chartWidget: _buildBarChart(context, monthlySummary, currency),
              noDataMessage: 'No transaction data available for the Bar Chart.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(
      BuildContext context, ColorScheme colorScheme, {
        required String title,
        required Widget chartWidget,
        Widget? legendWidget,
        required String noDataMessage,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: colorScheme.outline.withAlpha(153),
              width: 1.0,
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                chartWidget,
                if (legendWidget != null) ...[
                  const SizedBox(height: 16),
                  legendWidget,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, double> categoryExpenses, double totalExpense) {
    if (categoryExpenses.isEmpty || totalExpense == 0) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No expense data available for the Pie Chart.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final List<PieChartSectionData> pieSections = [];
    final List<Color> colorPalette = [
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.surfaceContainerHighest,
      Colors.cyan, Colors.lime, Colors.pink,
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

    return SizedBox(
      height: 270,
      child: PieChart(
        PieChartData(
          sections: pieSections,
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildPieChartLegend(BuildContext context, Map<String, double> categoryExpenses) {
    final List<Color> colorPalette = [
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.surfaceContainerHighest,
      Colors.cyan, Colors.lime, Colors.pink,
    ];
    int colorIndex = 0;

    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: categoryExpenses.entries.map((entry) {
        final color = colorPalette[colorIndex % colorPalette.length];
        colorIndex++;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3)
            ),),
            const SizedBox(width: 6),
            Text(entry.key, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
          ],
        );
      }).toList(),
    );
  }


  Widget _buildBarChart(BuildContext context, Map<String, Map<String, double>> monthlySummary, String currency) {
    final colorScheme = Theme.of(context).colorScheme;

    if (monthlySummary.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No transaction data available for the Bar Chart.',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final List<String> sortedMonths = monthlySummary.keys.toList();
    final List<String> lastSixMonths = sortedMonths.length > 6 ? sortedMonths.sublist(sortedMonths.length - 6) : sortedMonths;

    double maxAmount = 0;

    for (var monthKey in lastSixMonths) {
      final data = monthlySummary[monthKey]!;
      maxAmount = max(maxAmount, data['income'] ?? 0);
      maxAmount = max(maxAmount, data['expense'] ?? 0);
    }

    final List<BarChartGroupData> barGroups = lastSixMonths.asMap().entries.map((entry) {
      final index = entry.key;
      final monthKey = entry.value;
      final data = monthlySummary[monthKey]!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data['income'] ?? 0,
            color: colorScheme.primary,
            width: 10,
            borderRadius: BorderRadius.circular(3),
          ),
          BarChartRodData(
            toY: data['expense'] ?? 0,
            color: colorScheme.error,
            width: 10,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      );
    }).toList();

    final double gridInterval = maxAmount > 0 ? maxAmount / 4.5 : 1000;

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxAmount * 1.25,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String label;
                if (rodIndex == 0) {
                  label = 'Income: $currency${rod.toY.toStringAsFixed(0)}';
                } else {
                  label = 'Expense: $currency${rod.toY.toStringAsFixed(0)}';
                }
                return BarTooltipItem(
                  label,
                  TextStyle(color: colorScheme.onPrimary, fontSize: 12),
                  children: [
                    TextSpan(
                      text: '\n${lastSixMonths[group.x.toInt()].split('-')[1]}',
                      style: TextStyle(color: colorScheme.onPrimary.withAlpha(178), fontSize: 10),
                    ),
                  ],
                );
              },
            ),
          ),
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
                      child: Text(monthAbbr, style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: gridInterval,
                  reservedSize: 60,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= (maxAmount * 1.25).toInt() - 1) {
                      return const SizedBox();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                          '$currency${value.toInt()}',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant)
                      ),
                    );
                  },
                )
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outline.withAlpha(102),
              strokeWidth: 0.5,
            ),
            horizontalInterval: gridInterval,
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}