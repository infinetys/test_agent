import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'covid_api.dart';
import 'covid_stat_card.dart';
import 'covid_line_chart.dart';
import 'province_covid_table.dart';
import 'notification_service.dart';
import 'sex_age_table.dart';
import 'at_risk_table.dart';
import 'vaccine_table.dart';
import 'hospital_bed_table.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('th');

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      locale: _locale,
      supportedLocales: const [
        Locale('th'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        onLocaleChange: _changeLocale,
        currentLocale: _locale,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final void Function(Locale)? onLocaleChange;
  final Locale? currentLocale;
  const MyHomePage({super.key, required this.title, this.onLocaleChange, this.currentLocale});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? todaySummary;
  List<Map<String, dynamic>> timeline = [];
  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> sexAge = [];
  List<Map<String, dynamic>> atRisk = [];
  List<Map<String, dynamic>> vaccineByProvince = [];
  List<Map<String, dynamic>> hospitalBeds = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final summary = await CovidApi.fetchTodaySummaryWithFallback();
      final timelineData = await CovidApi.fetchTimelineWithFallback();
      final provinceData = await CovidApi.fetchProvincesWithFallback();
      final sexAgeData = await CovidApi.fetchSexAgeWithFallback();
      final atRiskData = await CovidApi.fetchAtRiskWithFallback();
      final vaccineData = await CovidApi.fetchVaccineByProvinceWithFallback();
      final bedData = await CovidApi.fetchHospitalBedWithFallback();
      setState(() {
        todaySummary = summary;
        timeline = timelineData;
        provinces = provinceData;
        sexAge = sexAgeData;
        atRisk = atRiskData;
        vaccineByProvince = vaccineData;
        hospitalBeds = bedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('สถานการณ์โควิด-19 ประเทศไทย'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
            tooltip: 'รีเฟรชข้อมูล',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: 'ทดสอบแจ้งเตือน',
            onPressed: () async {
              await NotificationService.showNotification(
                id: 1,
                title: Localizations.localeOf(context).languageCode == 'th' ? 'แจ้งเตือนโควิด' : 'COVID Alert',
                body: Localizations.localeOf(context).languageCode == 'th'
                  ? 'มีการอัปเดตข้อมูลโควิด-19 รายวันแล้ว'
                  : 'COVID-19 daily update is available',
              );
            },
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: 'เปลี่ยนภาษา / Change language',
            onSelected: (locale) {
              widget.onLocaleChange?.call(locale);
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: const Locale('th'),
                checked: widget.currentLocale?.languageCode == 'th',
                child: const Text('ไทย'),
              ),
              CheckedPopupMenuItem(
                value: const Locale('en'),
                checked: widget.currentLocale?.languageCode == 'en',
                child: const Text('English'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('เกิดข้อผิดพลาด: \n$error', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: fetchData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('ลองใหม่'),
                      ),
                    ],
                  ),
                )
              : todaySummary == null
                  ? const Center(child: Text('ไม่พบข้อมูล'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CovidStatCard(todaySummary: todaySummary!),
                          const SizedBox(height: 24),
                          Text('กราฟผู้ติดเชื้อรายวัน', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 250,
                            child: CovidLineChart(timeline: timeline),
                          ),
                          ProvinceCovidTable(
                            provinces: provinces,
                            tr: (th, en) => Localizations.localeOf(context).languageCode == 'th' ? th : en,
                          ),
                          SexAgeTable(
                            data: sexAge,
                            tr: (th, en) => Localizations.localeOf(context).languageCode == 'th' ? th : en,
                          ),
                          AtRiskTable(
                            data: atRisk,
                            tr: (th, en) => Localizations.localeOf(context).languageCode == 'th' ? th : en,
                          ),
                          VaccineTable(
                            data: vaccineByProvince,
                            tr: (th, en) => Localizations.localeOf(context).languageCode == 'th' ? th : en,
                          ),
                          HospitalBedTable(
                            data: hospitalBeds,
                            tr: (th, en) => Localizations.localeOf(context).languageCode == 'th' ? th : en,
                          ),
                        ],
                      ),
                    ),
    );
  }
}
