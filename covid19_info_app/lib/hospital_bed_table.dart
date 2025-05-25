import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HospitalBedTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String Function(String th, String en) tr;
  const HospitalBedTable({super.key, required this.data, required this.tr});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text(tr('ไม่มีข้อมูลเตียง', 'No hospital bed data')));
    }
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(tr('ข้อมูลเตียงโรงพยาบาล', 'Hospital Bed Info'), style: Theme.of(context).textTheme.titleMedium),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(tr('โรงพยาบาล', 'Hospital'))),
                DataColumn(label: Text(tr('จังหวัด', 'Province'))),
                DataColumn(label: Text(tr('เตียงทั้งหมด', 'Total Beds'))),
                DataColumn(label: Text(tr('เตียงว่าง', 'Available Beds'))),
                DataColumn(label: Text(tr('เตียงใช้แล้ว', 'Used Beds'))),
              ],
              rows: data.map((e) {
                return DataRow(cells: [
                  DataCell(Text(e['hospname'] ?? '-')),
                  DataCell(Text(e['province'] ?? '-')),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['total_bed'] ?? 0))),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['bed_avail'] ?? 0))),
                  DataCell(Text(NumberFormat.decimalPattern().format(e['bed_used'] ?? 0))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
