import 'package:f1info/api/countries.dart';
import 'package:f1info/services/auth/auth_service.dart';
import 'package:f1info/views/detail_view.dart';
import 'package:flutter/material.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  List<Country> _favorites = [];
  final AuthService _authService = AuthService.firebase();

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final currentUserEmail = _authService.getCurrentUserEmail();
      if (currentUserEmail != null) {
        final favorites = await _authService.getFavorites(currentUserEmail);
        setState(() {
          _favorites = favorites;
        });
      }
    } catch (e) {
      // Manejar el error
      throw ('Error al cargar los favoritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDD6CC),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Favorite Countries',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A4C41),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final country = _favorites[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryDetailsPage(country: country),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: const Color(0xFF19222B),
                      ),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        country.flags.png,
                        width: 48,
                        height: 48,
                      ),
                      title: Text(
                        country.name.common,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Color(0xFF19222B),
                        ),
                      ),
                      // Mostrar otros detalles del país si es necesario
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
