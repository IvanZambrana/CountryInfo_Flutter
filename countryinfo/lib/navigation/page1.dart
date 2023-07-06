import 'package:f1info/api/api_country_provider.dart';
import 'package:f1info/api/countries.dart';
import 'package:f1info/services/auth/auth_service.dart';
import 'package:f1info/views/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Country> countries = [];
  bool isLoading = true;

  //Filter Countries
  final TextEditingController _searchController = TextEditingController();

  List<Country> _filteredCountries = [];

  final AuthService _authService = AuthService.firebase();

  ScaffoldMessengerState? _scaffoldMessengerState;

  Map<String, bool> favorites = {};

  late SharedPreferences _prefs;

  void _filterCountries(String searchText) {
    setState(() {
      _filteredCountries = countries.where((country) {
        final name = country.name.common.toLowerCase();
        return name.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchCountryData();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchCountryData() async {
    final apiProvider = ApiCountryProvider();
    final List<Country> countryList = await apiProvider.fetchCountryData();

    setState(() {
      countries = countryList;
      _filteredCountries = countries;
      isLoading = false;
      restoreFavorites();
    });
  }

  void restoreFavorites() {
    favorites.clear();
    for (final country in countries) {
      final isFavorite = _prefs.getBool(country.name.common) ?? false;
      setState(() {
        favorites[country.name.common] = isFavorite;
      });
    }
  }

  //Add to favorites
  Future<void> addToFavorites(Country country) async {
    final currentUserEmail = _authService.getCurrentUserEmail();
    if (currentUserEmail != null) {
      try {
        await _authService.addToFavorites(currentUserEmail, country);
        setState(() {
          favorites[country.name.common] = true;
          toggleFavorite(country.name.common, true);
        });
        _scaffoldMessengerState?.showSnackBar(
          const SnackBar(content: Text('Country added to favorites')),
        );
      } catch (e) {
        _scaffoldMessengerState?.showSnackBar(
          const SnackBar(content: Text('Failed to add country to favorites')),
        );
      }
    } else {
      _scaffoldMessengerState?.showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }

  //Remove from favorites
  Future<void> removeFromFavorites(Country country) async {
    final currentUserEmail = _authService.getCurrentUserEmail();
    if (currentUserEmail != null) {
      try {
        await _authService.removeFromFavorites(currentUserEmail, country);
        setState(() {
          favorites[country.name.common] = false;
          toggleFavorite(country.name.common, false);
        });
        _scaffoldMessengerState?.showSnackBar(
          const SnackBar(content: Text('Country removed from favorites')),
        );
      } catch (e) {
        _scaffoldMessengerState?.showSnackBar(
          const SnackBar(
              content: Text('Failed to remove country from favorites')),
        );
      }
    } else {
      _scaffoldMessengerState?.showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }

  void toggleFavorite(String countryName, bool isFavorite) {
    _prefs.setBool(countryName, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldMessengerState ??= ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFDDD6CC),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filterCountries(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search country...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF5A4C41),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _filteredCountries.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      var isFavorite = favorites[country.name.common] ?? false;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CountryDetailsPage(country: country),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
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
                                color: Color(0xFF5A4C41),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite
                                    ? const Color(0xFFBD9240)
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                  toggleFavorite(
                                      country.name.common, isFavorite);
                                  if (isFavorite) {
                                    addToFavorites(country);
                                  } else {
                                    removeFromFavorites(country);
                                  }
                                });
                              },
                            ),
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
