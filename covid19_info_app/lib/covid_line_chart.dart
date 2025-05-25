import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovidLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;
  const CovidLineChart({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    if (timeline.isEmpty) {
      return const Center(child: Text('ไม่มีข้อมูลกราฟ'));
    }
    // ใช้ field 'new_case' และ 'txn_date' จาก API ไทย
    final filtered = timeline.where((e) => (e["new_case"] as num?) != null && (e["new_case"] as num) > 0).toList();
    final last30 = filtered.length > 30 ? filtered.sublist(filtered.length - 30) : filtered;
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= last30.length) return const SizedBox.shrink();
                final rawDate = last30[idx]["txn_date"] ?? last30[idx]["date"];
                String dateStr = rawDate?.toString() ?? "";
                if (dateStr.isEmpty || dateStr == "null") {
                  print("[CovidLineChart] Warning: dateStr is empty or null at idx $idx");
                  return const Text("-");
                }
                try {
                  // ตรวจสอบรูปแบบวันที่เบื้องต้น (YYYY-MM-DD)
                  if (!RegExp(r"^\\d{4}-\\d{2}-\\d{2}").hasMatch(dateStr)) {
                    print("[CovidLineChart] Warning: dateStr format invalid: $dateStr at idx $idx");
                    return Text(dateStr);
                  }
                  final date = DateTime.parse(dateStr);
                  return Text(DateFormat('d/M').format(date));
                } catch (e) {
                  print("[CovidLineChart] Error parsing date: $dateStr at idx $idx, error: $e");
                  return Text(dateStr);
                }
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < last30.length; i++)
                FlSpot(i.toDouble(), (last30[i]["new_case"] as num?)?.toDouble() ?? 0),
            ],
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

extension TakeLastExtension<E> on List<E> {
  Iterable<E> takeLast(int n) => skip(length - n < 0 ? 0 : length - n);
}
