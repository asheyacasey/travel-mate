import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:travel_mate/models/location_model.dart';
import 'package:travel_mate/repositories/repositories.dart';

class LocationRepository extends BaseLocationRepository {
  final String key = 'AIzaSyBvM8gy2wxralXZ1pyOyfIhmR_o7FjGmLM';
  final String types = 'geocode';

  static const baseUrl = 'https://maps.googleapis.com/maps/api/place';

  @override
  Future<Location> getLocation(String location) async {
    final String url =
        '$baseUrl/findplacefromtext/json?fields=place_id%2Cname%2Cgeometry&input=$location&inputtype=textquery&key=AIzaSyCq1ARFZxtzy7raHdy5HyeAeCsZ_wTsRH0';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['candidates'][0] as Map<String, dynamic>;
    return Location.fromJson(results);
  }
}
