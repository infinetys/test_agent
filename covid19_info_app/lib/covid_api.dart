import 'dart:convert';
import 'package:http/http.dart' as http;

class CovidApi {
  static const String summaryUrl = 'https://covid19.ddc.moph.go.th/api/Cases/today-cases-all';
  static const String timelineUrl = 'https://covid19.ddc.moph.go.th/api/Cases/timeline-cases-all';
  static const String provinceUrl = 'https://covid19.ddc.moph.go.th/api/Cases/today-cases-by-provinces';
  static const String sexAgeUrl = 'https://covid19.ddc.moph.go.th/api/Cases/sex-age-group';
  static const String atRiskUrl = 'https://covid19.ddc.moph.go.th/api/Cases/at-risk';
  static const String amphurUrl = 'https://covid19.ddc.moph.go.th/api/Cases/today-cases-by-amphur';
  static const String foreignUrl = 'https://covid19.ddc.moph.go.th/api/Cases/today-cases-foreign';
  static const String vaccineProvinceUrl = 'https://covid19.ddc.moph.go.th/api/Vaccine/vaccine-by-province';
  static const String vaccineCoverageUrl = 'https://covid19.ddc.moph.go.th/api/Vaccine/vaccine-coverage';
  static const String hospitalBedUrl = 'https://covid19.ddc.moph.go.th/api/Hospital/hospital-bed';

  static Future<Map<String, dynamic>?> fetchTodaySummary() async {
    print('[API] Fetching summary: $summaryUrl');
    final response = await http.get(Uri.parse(summaryUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List && data.isNotEmpty) {
        return data[0] as Map<String, dynamic>;
      }
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchTimeline() async {
    print('[API] Fetching timeline: $timelineUrl');
    final response = await http.get(Uri.parse(timelineUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchProvinces() async {
    print('[API] Fetching provinces: $provinceUrl');
    final response = await http.get(Uri.parse(provinceUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchSexAge() async {
    print('[API] Fetching sex/age: $sexAgeUrl');
    final response = await http.get(Uri.parse(sexAgeUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchAtRisk() async {
    print('[API] Fetching at-risk: $atRiskUrl');
    final response = await http.get(Uri.parse(atRiskUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchAmphur() async {
    print('[API] Fetching amphur: $amphurUrl');
    final response = await http.get(Uri.parse(amphurUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchForeign() async {
    print('[API] Fetching foreign: $foreignUrl');
    final response = await http.get(Uri.parse(foreignUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchVaccineByProvince() async {
    print('[API] Fetching vaccine by province: $vaccineProvinceUrl');
    final response = await http.get(Uri.parse(vaccineProvinceUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchVaccineCoverage() async {
    print('[API] Fetching vaccine coverage: $vaccineCoverageUrl');
    final response = await http.get(Uri.parse(vaccineCoverageUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> fetchHospitalBed() async {
    print('[API] Fetching hospital bed: $hospitalBedUrl');
    final response = await http.get(Uri.parse(hospitalBedUrl));
    print('[API] Response status: \'${response.statusCode}\'');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[API] Response data: $data');
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<Map<String, dynamic>?> fetchTodaySummaryWithFallback() async {
    // Try main summary API first
    final summary = await fetchTodaySummary();
    if (summary != null) return summary;
    // Fallback: use latest from timeline
    final timeline = await fetchTimeline();
    if (timeline.isNotEmpty) {
      // สมมติว่า timeline เรียงจากเก่าสุด -> ใหม่สุด
      final latest = timeline.last;
      // Map timeline fields to summary fields (ปรับตามโครงสร้างจริง)
      return {
        'date': latest['txn_date'] ?? latest['date'],
        'todayCases': latest['new_case'] ?? 0,
        'todayRecovered': latest['new_recovered'] ?? 0,
        'todayDeaths': latest['new_death'] ?? 0,
        'cases': latest['total_case'] ?? 0,
        'recovered': latest['total_recovered'] ?? 0,
        'deaths': latest['total_death'] ?? 0,
        'updated': DateTime.now().millisecondsSinceEpoch,
      };
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchTimelineWithFallback() async {
    try {
      return await fetchTimeline();
    } catch (e) {
      print('[API] Timeline fallback error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProvincesWithFallback() async {
    try {
      return await fetchProvinces();
    } catch (e) {
      print('[API] Provinces fallback error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSexAgeWithFallback() async {
    try {
      return await fetchSexAge();
    } catch (e) {
      print('[API] SexAge fallback error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAtRiskWithFallback() async {
    try {
      return await fetchAtRisk();
    } catch (e) {
      print('[API] AtRisk fallback error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchVaccineByProvinceWithFallback() async {
    try {
      return await fetchVaccineByProvince();
    } catch (e) {
      print('[API] VaccineByProvince fallback error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchHospitalBedWithFallback() async {
    try {
      return await fetchHospitalBed();
    } catch (e) {
      print('[API] HospitalBed fallback error: $e');
      return [];
    }
  }
}
