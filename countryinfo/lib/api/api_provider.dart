import 'package:http/http.dart' as http;

import 'constructor_standings.dart';

void fetchF1Data(Function(List<ConstructorStanding>) callback) async {
  var url = Uri.parse('http://ergast.com/api/f1/current/constructorStandings.json');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonString = response.body;
    var data = welcomeFromJson(jsonString);
    var standingsList = data.mrData.standingsTable.standingsLists.first;
    var constructorStandings = standingsList.constructorStandings;

    callback(constructorStandings);
  } else {
  }
}
