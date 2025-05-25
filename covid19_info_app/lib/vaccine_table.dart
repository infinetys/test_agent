import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaccineTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String Function(String th, String en) tr;
  const VaccineTable({super.key, required this.data, required this.tr});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text(tr('ไม่มีข้อมูลวัคซีน', 'No vaccine data')));
    }
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(tr('ข้อมูลวัคซีนรายจังหวัด', 'Vaccine by Province'), style: Theme.of(context).textTheme.titleMedium),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(tr('จังหวัด', 'Province'))),
                DataColumn(label: Text(tr('เข็ม 1', 'Dose 1'))),
                DataColumn(label: Text(tr('เข็ม 2', 'Dose 2'))),
                DataColumn(label: Text(tr('เข็ม 3', 'Dose 3'))),
                DataColumn(label: Text(tr('รวม', 'Total'))),
              ],
              rows: data.map((e) {
                return DataRow(cells: [
                  DataCell(Text(e['province'] ?? '-')),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['1stDose'] ?? 0))),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['2ndDose'] ?? 0))),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['3rdDose'] ?? 0))),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['total'] ?? 0))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
