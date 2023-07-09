import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Sholat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PrayerTime> prayerTimes = [];

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final response = await http.get(
      Uri.parse(
          'https://raw.githubusercontent.com/lakuapik/jadwalsholatorg/master/adzan/bekasi/2023/06.json'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<PrayerTime> times = [];
      for (var data in jsonData) {
        final prayerTime = PrayerTime(
          date: data['tanggal'] ?? '',
          shubuh: data != null ? data['shubuh'] ?? '' : '',
          dzuhur: data != null ? data['dzuhur'] ?? '' : '',
          ashr: data != null ? data['ashr'] ?? '' : '',
          magrib: data != null ? data['magrib'] ?? '' : '',
          isya: data != null ? data['isya'] ?? '' : '',
        );
        times.add(prayerTime);
      }
      setState(() {
        prayerTimes = times;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Sholat Bekasi'),
      ),
      body: ListView.builder(
        itemCount: prayerTimes.length,
        itemBuilder: (context, index) {
          final time = prayerTimes[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                'Date: ${time.date}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Shubuh: ${time.shubuh}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Dzuhur: ${time.dzuhur}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Ashr: ${time.ashr}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Maghrib: ${time.magrib}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Isya: ${time.isya}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PrayerTime {
  final String date;
  final String shubuh;
  final String dzuhur;
  final String ashr;
  final String magrib;
  final String isya;

  PrayerTime({
    required this.date,
    required this.shubuh,
    required this.dzuhur,
    required this.ashr,
    required this.magrib,
    required this.isya,
  });
}
