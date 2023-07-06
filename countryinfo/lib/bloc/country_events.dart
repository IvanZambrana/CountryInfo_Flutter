
import 'package:f1info/api/countries.dart';
import 'package:equatable/equatable.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object> get props => [];
}

class AddToFavorite extends CountryEvent {
  final Country country;

  const AddToFavorite(this.country);

  @override
  List<Object> get props => [country];
}

class RemoveFromFavorite extends CountryEvent {
  final Country country;

  const RemoveFromFavorite(this.country);

  @override
  List<Object> get props => [country];
}
