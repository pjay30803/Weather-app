import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weatherData = weatherProvider.weatherData;

    Future<void> saveCity(String city) async {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedCities = prefs.getStringList('saved_cities') ?? [];

      if (!savedCities.contains(city)) {
        savedCities.add(city);
        await prefs.setStringList('saved_cities', savedCities);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$city saved!')),
        );
      }
    }

    if (weatherData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weather Details')),
        body: const Center(
          child: Text('No weather data available.',
              style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${weatherData.city} Weather'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => saveCity(weatherData.city),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.thermostat,
                        size: 80, color: Colors.orange),
                    Text(
                      '${weatherData.temperature}°C',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.water_drop,
                            color: Colors.blueGrey, size: 26),
                        const SizedBox(width: 10),
                        Text('Humidity: ${weatherData.humidity}%',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.air, color: Colors.blueGrey, size: 26),
                        const SizedBox(width: 10),
                        Text('Wind Speed: ${weatherData.windSpeed} km/h',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny,
                            color: Colors.orange, size: 26),
                        const SizedBox(width: 10),
                        Text('Sunrise: ${weatherData.sunrise}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.nights_stay,
                            color: Colors.indigo, size: 26),
                        const SizedBox(width: 10),
                        Text('Sunset: ${weatherData.sunset}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_city', city);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$city saved for later!')),
    );
  }
}
