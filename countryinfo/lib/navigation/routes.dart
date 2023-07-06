import 'package:f1info/navigation/fav_page.dart';
import 'package:f1info/navigation/page1.dart';
import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> myRoutes = [
      const MainPage(),
      const FavPage(),
    ];
    return myRoutes[index];
  }
}
