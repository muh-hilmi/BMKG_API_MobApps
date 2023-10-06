import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

import 'DetailGempa.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EarthquakeData>? earthquakeDataList; // Ubah tipe data menjadi nullable
  bool isFetchingData = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void showDataUpdatedNotification() {
    Fluttertoast.showToast(
      msg: 'Data diperbarui!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true; // Set state ke true saat memulai request.
    });
    final response = await http.get(
        Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> gempaList = data['Infogempa']['gempa'];

      setState(() {
        earthquakeDataList =
            gempaList.map((json) => EarthquakeData.fromJson(json)).toList();
        isFetchingData = false;
      });
      showDataUpdatedNotification();
    } else {
      // Penanganan kesalahan
      setState(() {
        earthquakeDataList = [];
        isFetchingData = false;
      });
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Gempa BMKG'),
        ),
        body: isFetchingData
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchData,
                child: ListView.builder(
                  itemCount: earthquakeDataList!.length,
                  itemBuilder: (context, index) {
                    final data = earthquakeDataList![index];
                    return ListTile(
                      title: Text(data.jam + " " + data.tanggal),
                      subtitle: Text(data.wilayah),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailGempa(data),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class EarthquakeData {
  final String tanggal;
  final String jam;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;

  EarthquakeData({
    required this.tanggal,
    required this.jam,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
  });

  factory EarthquakeData.fromJson(Map<String, dynamic> json) {
    return EarthquakeData(
      tanggal: json['Tanggal'],
      jam: json['Jam'],
      coordinates: json['Coordinates'],
      lintang: json['Lintang'],
      bujur: json['Bujur'],
      magnitude: json['Magnitude'],
      kedalaman: json['Kedalaman'],
      wilayah: json['Wilayah'],
      potensi: json['Potensi'],
    );
  }
}
