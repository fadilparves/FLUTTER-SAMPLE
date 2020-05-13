import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString("assets/key.json");
}

class LocationHelper {
  static Future<String> generateLocationPreviewImage({double latitude, double longitude}) async {
    String GOOGLE_API_KEY;
    await loadAsset().then((value) {
      GOOGLE_API_KEY = value;
    });
    
    GOOGLE_API_KEY = json.decode(GOOGLE_API_KEY)['GOOGLE_API_KEY'];
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    String GOOGLE_API_KEY;
    await loadAsset().then((value) {
      GOOGLE_API_KEY = value;
    });
    
    GOOGLE_API_KEY = json.decode(GOOGLE_API_KEY)['GOOGLE_API_KEY'];
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}