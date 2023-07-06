import 'dart:convert';
import 'package:http/http.dart' as http;
import 'countries.dart';

class ApiCountryProvider {
  Future<List<Country>> fetchCountryData() async {
    final response = await http.get(Uri.parse(
        'https://restcountries.com/v3.1/all?fields=name,flags,capital,languages,currencies,region'));

    if (response.statusCode == 200) {
      /* final jsonData = jsonDecode(response.body) as List<dynamic>;
      final List<Country> countryList = jsonData.map((item) {
        return Country(
          name: item['name']['common'],
          flags: item['flags']['png'],
          capital: item['capital'][0],
          languages: item['languages'].keys.toList(),
          currencies: item['currencies'].keys.toList(),
          region: item['region'],
        );
      }).toList();
*/
      final jsonData = json.decode(response.body);
      final countriesJson = jsonData as List<dynamic>;

      List<Country> countryList = countriesJson.map((countryJson) {
        return Country.fromJson(countryJson);
      }).toList();

      return countryList;
    } else {
      throw Exception('Failed to fetch country data');
    }
  }
}
