import 'package:flutter/material.dart';

class BNavigator extends StatefulWidget {
  final Function currentIndex;
  const BNavigator({Key? key, required this.currentIndex}) : super(key:key);

  @override
  _BNavigatorState createState() =>  _BNavigatorState();
}

class  _BNavigatorState extends State<BNavigator> {

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i){
        setState(() {
          index = i;
          widget.currentIndex(i);
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFBD9240),
      unselectedItemColor: const Color(0xFFDDD6CC),
      iconSize: 25.0,
      selectedFontSize: 14.0,
      unselectedFontSize: 12.0,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: const Color(0xFF19222B),
      items : const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Favourites',
        ),
      ],
    );
  }
}