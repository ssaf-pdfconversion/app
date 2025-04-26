import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Clase de datos para la gráfica
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

/// Método que genera un widget de gráfica de barras a partir de una lista de ChartData.
Widget buildBarChart(
  List<ChartData> data) {
    final maxY = data.isNotEmpty ? data.map((d) => d.y).reduce(max) : 0.0;
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(isVisible: false,),
    primaryYAxis: NumericAxis(minimum: 0, maximum: maxY),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: <CartesianSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: data,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        name: 'MB',
        color: Colors.deepPurple[400],
      ),
    ],
  );
}

List<ChartData> convertRawStatsToChartData(
  dynamic rawStats,
) {
  // Aplanar si viene envuelto en un array extra
  List<dynamic> entries;
  if (rawStats is List && rawStats.isNotEmpty && rawStats.first is List) {
    entries = (rawStats).expand((e) => e as List).toList();
  } else if (rawStats is List) {
    entries = rawStats;
  } else {
    throw ArgumentError('Se esperaba una lista de estadísticas, pero se obtuvo: \$rawStats');
  }

  return entries.map((item) {
    final String date = item['date'].toString();
    // Manejar totalMB como numérico o string
    final String mbString = item['totalMB'].toString();
    final double mbValue = double.tryParse(mbString.replaceAll(',', '.')) ??
        (item['totalMB'] is num ? (item['totalMB'] as num).toDouble() : 0.0);
    return ChartData(date, mbValue);
  }).toList();
}
