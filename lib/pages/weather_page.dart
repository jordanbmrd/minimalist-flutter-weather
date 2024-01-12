import 'package:flutter/material.dart';
import 'package:flutter_weather/api_key.dart';
import 'package:flutter_weather/models/weather_model.dart';
import 'package:flutter_weather/services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherService = WeatherService(ApiKeys.openWeatherMap);
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    // Get current position
    Position position = await weatherService.getPosition();

    // Get weather for coordinates
    try {
      final weather = await weatherService.getWeather(position.latitude, position.longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // Sunny by default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Initialize state
  @override
  void initState() {
    super.initState();

    // Fetch weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.place,
              color: Colors.grey,
              size: 24,
              semanticLabel: 'Pin',
            ),

            const SizedBox(height: 10),

            // City name
            Text(_weather?.cityName.toUpperCase() ?? "Loading city...",
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 100),

            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            const SizedBox(height: 140),

            // Temperature
            Text(_weather?.temperature != null ? "${_weather?.temperature.round()}°C" : "",
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.w500,
                fontSize: 36,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
    );
  }
}