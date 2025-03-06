import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_screen.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';

class SavedCitiesScreen extends StatefulWidget {
  @override
  _SavedCitiesScreenState createState() => _SavedCitiesScreenState();
}

class _SavedCitiesScreenState extends State<SavedCitiesScreen> {
  List<String> savedCities = [];

  @override
  void initState() {
    super.initState();
    loadSavedCities();
  }

  Future<void> loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCities = prefs.getStringList('saved_cities') ?? [];
    });
  }

  Future<void> removeCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCities.remove(city);
    });
    await prefs.setStringList('saved_cities', savedCities);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Cities')),
      body: savedCities.isEmpty
          ? const Center(child: Text('No saved cities'))
          : ListView.builder(
              itemCount: savedCities.length,
              itemBuilder: (context, index) {
                final city = savedCities[index];
                return ListTile(
                  title: Text(city),
                  leading: const Icon(Icons.location_city, color: Colors.blue),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeCity(city),
                  ),
                  onTap: () {
                    weatherProvider.fetchWeather(city);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
