import 'package:f1info/api/countries.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CountryDetailsPage extends StatelessWidget {
  final Country country;

  const CountryDetailsPage({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final capital = country.capital.map((c) => utf8.decode(c.codeUnits)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Country detail',
          style: TextStyle(
            color: Color(0xFFDDD6CC),
          ),
        ),
        backgroundColor: const Color(0xFFB84357),
        iconTheme: const IconThemeData(
          color: Color(0xFFDDD6CC),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF19222B),
              Color(0xFF0D1318),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: Image.network(
                country.flags.png,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Common name: ${country.name.common}',
              style: const TextStyle(
                color: Color(0xFFBD9240),
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Capital: ${capital.isNotEmpty ? capital[0] : ""}',
              style: const TextStyle(
                color: Color(0xFFDDD6CC),
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              'Official name: ${country.name.official}',
              style: const TextStyle(
                color: Color(0xFFDDD6CC),
                fontSize: 16.0,
              ),
            ),
            Text(
              'Region: ${country.region.name}',
              style: const TextStyle(
                color: Color(0xFFDDD6CC),
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
