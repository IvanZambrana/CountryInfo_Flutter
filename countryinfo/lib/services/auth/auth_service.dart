import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1info/api/countries.dart';
import 'package:f1info/services/auth/auth_provider.dart';
import 'package:f1info/services/auth/auth_user.dart';
import 'package:f1info/services/auth/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

/*
  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );
*/
  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    final authUser = await provider.createUser(
      email: email,
      password: password,
    );

    if (authUser != null) {
      final user = FirebaseAuth.instance.currentUser;

      // Guardar el email en Firestore
      await _usersCollection.add({
        'email': email,
        'userId': user?.uid,
      });
    }

    return authUser;
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  //Favorites logic
  // Agregar país a favoritos
  Future<void> addToFavorites(String? userEmail, Country country) async {
    try {
      final userSnapshot = await _usersCollection
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();
      final userDoc = userSnapshot.docs.first;
      final userId = userDoc.id;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(country.name.common)
          .set({
        'name': country.name.common,
        'flagPng': country.flags.png,
        'nameOfficial': country.name.official,
        'capital': country.capital,
        'region': country.region.toString().split('.')[1],
        // Otros datos relevantes del país que deseas guardar
      });
    } catch (e) {
      // Manejo de errores
      throw Exception('Failed to add country to favorites.');
    }
  }

// Obtener lista de países favoritos
/*
  Future<List<Country>> getFavorites(String? userEmail) async {
    try {
      final userSnapshot = await _usersCollection
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();
      final userDoc = userSnapshot.docs.first;
      final userId = userDoc.id;

      final favoritesSnapshot =
          await _usersCollection.doc(userId).collection('favorites').get();

      final favorites = favoritesSnapshot.docs.map((doc) async {
        final countryId = doc.id;

        final countrySnapshot = await _countriesCollection.doc(countryId).get();
        final countryData = countrySnapshot.data() as Map<String, dynamic>;

        final country = Country.fromJson(countryData);
        return country;
      }).toList();

      final results = await Future.wait(favorites);
      return results.whereType<Country>().toList();
    } catch (e) {
      // Manejo de errores
      throw Exception('Failed to get favorites.');
    }
  }
*/
  Future<List<Country>> getFavorites(String? userEmail) async {
    try {
      final userSnapshot = await _usersCollection
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userSnapshot.size > 0) {
        final userDoc = userSnapshot.docs.first;
        final userId = userDoc.id;

        final favoritesSnapshot =
            await _usersCollection.doc(userId).collection('favorites').get();

        final favorites = await Future.wait(
          favoritesSnapshot.docs.map((doc) async {
            final countryName = doc.id;
            final countryData = doc.data();

            final officialName = countryData['nameOfficial'] ?? '';
            final flagPng = countryData['flagPng'] ?? '';

            // final currenciesData = countryData['currencies'] ?? {};
            //final currencies =  currenciesData.map((key, value) => MapEntry(key, value));

            final capitalData = countryData['capital'] ?? [];
            final capital = (capitalData as List<dynamic>).map((item) => item.toString()).toList();

            final regionData = countryData['region'] ?? '';
            final region = Region.values.firstWhere((r) => r.toString() == 'Region.$regionData');

            //final languagesData = countryData['languages'] ?? {};
            //final languages = languagesData.map((key, value) => MapEntry(key, value));

            return Country(
              name: Name(
                  common: countryName, official: officialName, nativeName: {}),
              flags: Flags(png: flagPng, svg: '', alt: ''),
              currencies: {},
              capital: capital,
              region: region,
              languages: {},
            );
          }),
        );

        return favorites;
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      // Manejo de errores
      throw Exception('Failed to get favorites: $e');
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? getCurrentUserEmail() {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser?.email;
  }

  removeFromFavorites(String? userEmail, Country country) async {
    if (userEmail != null) {
      try {
        final userQuerySnapshot = await _usersCollection
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (userQuerySnapshot.size > 0) {
          final userDocumentSnapshot = userQuerySnapshot.docs.first;
          final userId = userDocumentSnapshot.id;

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .doc(country.name.common)
              .delete();
        } else {
          throw Exception('User not found.');
        }
      } catch (e) {
        // Manejo de errores
        throw Exception('Failed to remove country from favorites.');
      }
    } else {
      throw Exception('User email is null.');
    }
  }
}
