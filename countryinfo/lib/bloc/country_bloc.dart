import 'package:bloc/bloc.dart';
import 'package:f1info/api/countries.dart';
import 'package:f1info/bloc/country_events.dart';
import 'package:f1info/bloc/country_states.dart';
import 'package:f1info/services/auth/auth_service.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final AuthService authService;

  CountryBloc(this.authService) : super(CountryInitial());

  @override
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    if (event is AddToFavorite) {
      yield* _mapAddToFavoriteToState(event.country);
    } else if (event is RemoveFromFavorite) {
      yield* _mapRemoveFromFavoriteToState(event.country);
    }
  }

  Stream<CountryState> _mapAddToFavoriteToState(Country country) async* {
    yield CountryLoading();

    try {
      final user = 
          authService.currentUser; // Obtén el usuario actual del AuthService

      if (user != null) {

              final userEmail = authService.getCurrentUserEmail(); // Obtén el email del usuario actual

        
        // Agregar el país a la lista de favoritos del usuario en Firebase
      await authService.addToFavorites(userEmail, country);

      // Obtener la lista actualizada de favoritos del usuario
      final favorites = await authService.getFavorites(userEmail);

        yield CountryLoaded(favorites);
      } else {
        yield const CountryError('User is null.');
      }
    } catch (e) {
      yield const CountryError('Failed to add country to favorites.');
    }
  }

  Stream<CountryState> _mapRemoveFromFavoriteToState(Country country) async* {
    yield CountryLoading();

    try {
      final user =
          authService.currentUser; // Obtén el usuario actual del AuthService
      if (user != null) {
      final userEmail = authService.getCurrentUserEmail(); // Obtén el email del usuario actual

      // Eliminar el país de la lista de favoritos del usuario en Firebase
      await authService.removeFromFavorites(userEmail, country);

      // Obtener la lista actualizada de favoritos del usuario
      final favorites = await authService.getFavorites(userEmail);
        yield CountryLoaded(favorites);
      } else {
        yield const CountryError('User is null.');
      }
    } catch (e) {
      yield const CountryError('Failed to remove country from favorites.');
    }
  }
}
