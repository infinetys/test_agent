import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AtRiskTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String Function(String th, String en) tr;
  const AtRiskTable({super.key, required this.data, required this.tr});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text(tr('ไม่มีข้อมูลกลุ่มเสี่ยง', 'No at-risk data')));
    }
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(tr('กลุ่มเสี่ยง', 'At Risk Group'), style: Theme.of(context).textTheme.titleMedium),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(tr('กลุ่มเสี่ยง', 'Risk Group'))),
                DataColumn(label: Text(tr('จำนวน', 'Cases'))),
              ],
              rows: data.map((e) {
                return DataRow(cells: [
                  DataCell(Text(e['risk'] ?? '-')),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['count'] ?? 0))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
