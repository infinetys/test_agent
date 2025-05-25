import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovidStatCard extends StatelessWidget {
  final Map<String, dynamic> todaySummary;
  const CovidStatCard({super.key, required this.todaySummary});

  String _tr(BuildContext context, String th, String en) {
    Locale locale = Localizations.localeOf(context);
    return locale.languageCode == 'th' ? th : en;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.update, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(_tr(context, 'อัปเดตล่าสุด', 'Last update') + ': '
                  '${todaySummary["updated"] != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(todaySummary["updated"])) : "-"}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(context, _tr(context, 'ผู้ติดเชื้อ', 'Cases'), todaySummary["todayCases"], Colors.orange, Icons.sick),
                _buildStat(context, _tr(context, 'หายป่วย', 'Recovered'), todaySummary["todayRecovered"], Colors.green, Icons.healing),
                _buildStat(context, _tr(context, 'เสียชีวิต', 'Deaths'), todaySummary["todayDeaths"], Colors.red, Icons.airline_seat_flat),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(context, _tr(context, 'สะสม', 'Total'), todaySummary["cases"], Colors.orange.shade700, Icons.add_chart),
                _buildStat(context, _tr(context, 'หายป่วยสะสม', 'Total Recovered'), todaySummary["recovered"], Colors.green.shade700, Icons.emoji_emotions),
                _buildStat(context, _tr(context, 'เสียชีวิตสะสม', 'Total Deaths'), todaySummary["deaths"], Colors.red.shade700, Icons.sentiment_very_dissatisfied),
              ],
            ),
            const SizedBox(height: 16),
            if ((todaySummary["todayCases"] ?? 0) == 0 && (todaySummary["todayRecovered"] ?? 0) == 0 && (todaySummary["todayDeaths"] ?? 0) == 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _tr(context, 'ยังไม่มีรายงานข้อมูลประจำวันล่าสุด หรือข้อมูลอาจยังไม่อัปเดต',
                              'No daily report yet or data may not be updated.'),
                  style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, dynamic value, Color color, IconData icon) {
    final formatter = NumberFormat.decimalPattern(Localizations.localeOf(context).languageCode);
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        Text(formatter.format(value ?? 0), style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
