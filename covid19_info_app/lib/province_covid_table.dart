import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProvinceCovidTable extends StatelessWidget {
  final List<Map<String, dynamic>> provinces;
  final String Function(String th, String en) tr;
  const ProvinceCovidTable({super.key, required this.provinces, required this.tr});

  @override
  Widget build(BuildContext context) {
    if (provinces.isEmpty) {
      return Center(child: Text(tr('ไม่มีข้อมูลจังหวัด', 'No province data')));
    }
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(tr('สถานการณ์รายจังหวัด', 'By Province'), style: Theme.of(context).textTheme.titleMedium),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(tr('จังหวัด', 'Province'))),
                DataColumn(label: Text(tr('ผู้ติดเชื้อ', 'Cases'))),
                DataColumn(label: Text(tr('เสียชีวิต', 'Deaths'))),
              ],
              rows: provinces.map((p) {
                return DataRow(cells: [
                  DataCell(Text(p['province'] ?? '-')),
                  DataCell(Text(NumberFormat.decimalPattern().format(p['cases'] ?? 0))),
                  DataCell(Text(NumberFormat.decimalPattern().format(p['deaths'] ?? 0))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
