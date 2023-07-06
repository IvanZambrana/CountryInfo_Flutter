// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    MrData mrData;

    Welcome({
        required this.mrData,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        mrData: MrData.fromJson(json["MRData"]),
    );

    Map<String, dynamic> toJson() => {
        "MRData": mrData.toJson(),
    };
}

class MrData {
    String xmlns;
    String series;
    String url;
    String limit;
    String offset;
    String total;
    StandingsTable standingsTable;

    MrData({
        required this.xmlns,
        required this.series,
        required this.url,
        required this.limit,
        required this.offset,
        required this.total,
        required this.standingsTable,
    });

    factory MrData.fromJson(Map<String, dynamic> json) => MrData(
        xmlns: json["xmlns"],
        series: json["series"],
        url: json["url"],
        limit: json["limit"],
        offset: json["offset"],
        total: json["total"],
        standingsTable: StandingsTable.fromJson(json["StandingsTable"]),
    );

    Map<String, dynamic> toJson() => {
        "xmlns": xmlns,
        "series": series,
        "url": url,
        "limit": limit,
        "offset": offset,
        "total": total,
        "StandingsTable": standingsTable.toJson(),
    };
}

class StandingsTable {
    String season;
    List<StandingsList> standingsLists;

    StandingsTable({
        required this.season,
        required this.standingsLists,
    });

    factory StandingsTable.fromJson(Map<String, dynamic> json) => StandingsTable(
        season: json["season"],
        standingsLists: List<StandingsList>.from(json["StandingsLists"].map((x) => StandingsList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "season": season,
        "StandingsLists": List<dynamic>.from(standingsLists.map((x) => x.toJson())),
    };
}

class StandingsList {
    String season;
    String round;
    List<ConstructorStanding> constructorStandings;

    StandingsList({
        required this.season,
        required this.round,
        required this.constructorStandings,
    });

    factory StandingsList.fromJson(Map<String, dynamic> json) => StandingsList(
        season: json["season"],
        round: json["round"],
        constructorStandings: List<ConstructorStanding>.from(json["ConstructorStandings"].map((x) => ConstructorStanding.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "season": season,
        "round": round,
        "ConstructorStandings": List<dynamic>.from(constructorStandings.map((x) => x.toJson())),
    };
}

class ConstructorStanding {
    String position;
    String positionText;
    String points;
    String wins;
    Constructor constructor;

    ConstructorStanding({
        required this.position,
        required this.positionText,
        required this.points,
        required this.wins,
        required this.constructor,
    });

    factory ConstructorStanding.fromJson(Map<String, dynamic> json) => ConstructorStanding(
        position: json["position"],
        positionText: json["positionText"],
        points: json["points"],
        wins: json["wins"],
        constructor: Constructor.fromJson(json["Constructor"]),
    );

    Map<String, dynamic> toJson() => {
        "position": position,
        "positionText": positionText,
        "points": points,
        "wins": wins,
        "Constructor": constructor.toJson(),
    };
}

class Constructor {
    String constructorId;
    String url;
    String name;
    String nationality;

    Constructor({
        required this.constructorId,
        required this.url,
        required this.name,
        required this.nationality,
    });

    factory Constructor.fromJson(Map<String, dynamic> json) => Constructor(
        constructorId: json["constructorId"],
        url: json["url"],
        name: json["name"],
        nationality: json["nationality"],
    );

    Map<String, dynamic> toJson() => {
        "constructorId": constructorId,
        "url": url,
        "name": name,
        "nationality": nationality,
    };
}
