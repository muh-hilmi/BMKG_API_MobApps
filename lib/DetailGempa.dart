import 'package:flutter/material.dart';

import 'main.dart';

class DetailGempa extends StatelessWidget {
  final EarthquakeData earthquakeData;

  const DetailGempa(this.earthquakeData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Gempa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${earthquakeData.tanggal}'),
            Text('Jam: ${earthquakeData.jam}'),
            Text('Coordinates: ${earthquakeData.coordinates}'),
            Text('Lintang: ${earthquakeData.lintang}'),
            Text('Bujur: ${earthquakeData.bujur}'),
            Text('Magnitude: ${earthquakeData.magnitude}'),
            Text('Kedalaman: ${earthquakeData.kedalaman}'),
            Text('Wilayah: ${earthquakeData.wilayah}'),
            Text('Potensi: ${earthquakeData.potensi}'),
          ],
        ),
      ),
    );
  }
}
