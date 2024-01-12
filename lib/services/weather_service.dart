import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse('$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    print(response.body);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Unable to load weather data');
    }
  }

  Future<Position> getPosition() async {
    // Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }
}