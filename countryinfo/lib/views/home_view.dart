import 'package:f1info/navigation/bottom_nav.dart';
import 'package:f1info/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:f1info/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;
  BNavigator? bottomNavBar;

  @override
  void initState() {
    bottomNavBar = BNavigator(currentIndex: (i) {
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NationFi: Info about countries',
          style: TextStyle(
            color: Color(0xFFDDD6CC), // Set the desired font color here
          ),
        ),
        backgroundColor: const Color(0xFFB84357),
        actions: [
          PopupMenuButton<MenuAction>(
            color: const Color(0xFFDDD6CC),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                  } else {}
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: Routes(index: index),
      bottomNavigationBar: bottomNavBar,
      backgroundColor: const Color(0xFF19222B),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
