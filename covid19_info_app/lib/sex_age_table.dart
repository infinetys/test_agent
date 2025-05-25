import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SexAgeTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String Function(String th, String en) tr;
  const SexAgeTable({super.key, required this.data, required this.tr});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text(tr('ไม่มีข้อมูลกลุ่มอายุ/เพศ', 'No sex/age data')));
    }
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(tr('กลุ่มอายุและเพศ', 'Sex & Age Group'), style: Theme.of(context).textTheme.titleMedium),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(tr('เพศ', 'Sex'))),
                DataColumn(label: Text(tr('กลุ่มอายุ', 'Age Group'))),
                DataColumn(label: Text(tr('จำนวน', 'Cases'))),
              ],
              rows: data.map((e) {
                return DataRow(cells: [
                  DataCell(Text(e['sex'] ?? '-')),
                  DataCell(Text(e['age'] ?? '-')),
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
