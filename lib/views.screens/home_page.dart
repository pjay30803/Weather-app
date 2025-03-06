import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/theme_provider.dart';
import '../provider/weather_provider.dart';
import '../provider/internet_provider.dart'; // Import Internetprovider
import 'bookmark_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool isSearching = false;
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

  Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    if (!savedCities.contains(city)) {
      savedCities.add(city);
      await prefs.setStringList('saved_cities', savedCities);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final internetProvider =
        Provider.of<Internetprovider>(context); // Get Internetprovider instance

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavedCitiesScreen()));
            },
            icon: Icon(Icons.bookmark)),
        title: const Text('Sky Scrapper'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSearching
                ? [Colors.orange.shade100, Colors.blue.shade700]
                : [Colors.orange.shade100, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Internet Connectivity Status
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: internetProvider.connectivityResult ==
                          ConnectivityResult.none
                      ? Colors.red
                      : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  internetProvider.connectivityResult == ConnectivityResult.none
                      ? 'No Internet Connection'
                      : 'Connected: ${internetProvider.connectivityResult.toString().split('.').last}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Search Box
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  prefixIcon:
                      const Icon(Icons.location_city, color: Colors.blueGrey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      if (_cityController.text.isNotEmpty &&
                          internetProvider.connectivityResult !=
                              ConnectivityResult.none) {
                        setState(() => isSearching = !isSearching);
                        weatherProvider.fetchWeather(_cityController.text);
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 20),

              // Weather Display
              weatherProvider.isLoading
                  ? const CircularProgressIndicator()
                  : weatherProvider.weatherData == null
                      ? const Text(
                          'Search for a city to get weather updates',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on,
                                size: 40, color: Colors.redAccent),
                            Text(weatherProvider.weatherData!.city,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 10),
                            const Icon(Icons.thermostat,
                                size: 50, color: Colors.orange),
                            Text(
                                '${weatherProvider.weatherData!.temperature}°C',
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 10),
                            const SizedBox(height: 20),

                            // View Details Button
                            ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen()),
                                );
                                loadSavedCities(); // Reload saved cities after returning from details
                              },
                              icon: const Icon(Icons.info, size: 20),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../provider/theme_provider.dart';
// import '../provider/weather_provider.dart';
// import 'detail_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _cityController = TextEditingController();
//   bool isSearching = false;
//   List<String> savedCities = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadSavedCities();
//   }
//
//   Future<void> loadSavedCities() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       savedCities = prefs.getStringList('saved_cities') ?? [];
//     });
//   }
//
//   Future<void> saveCity(String city) async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!savedCities.contains(city)) {
//       savedCities.add(city);
//       await prefs.setStringList('saved_cities', savedCities);
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final weatherProvider = Provider.of<WeatherProvider>(context);
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sky Scrapper'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//                 themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
//             onPressed: () => themeProvider.toggleTheme(),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.blueGrey[900],
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isSearching
//                 ? [Colors.orange.shade100, Colors.blue.shade700]
//                 : [Colors.orange.shade100, Colors.blue.shade700],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Search Box
//               TextField(
//                 controller: _cityController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter city name',
//                   prefixIcon:
//                       const Icon(Icons.location_city, color: Colors.blueGrey),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.search, color: Colors.black),
//                     onPressed: () {
//                       if (_cityController.text.isNotEmpty) {
//                         setState(() => isSearching = !isSearching);
//                         weatherProvider.fetchWeather(_cityController.text);
//                         saveCity(_cityController.text);
//                       }
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Saved Cities
//               if (savedCities.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Saved Cities:',
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(height: 10),
//                     ...savedCities.map((city) => ListTile(
//                           title: Text(city,
//                               style: const TextStyle(color: Colors.white)),
//                           leading:
//                               const Icon(Icons.bookmark, color: Colors.yellow),
//                           onTap: () {
//                             weatherProvider.fetchWeather(city);
//                           },
//                         )),
//                   ],
//                 ),
//               const SizedBox(height: 20),
//
//               // Weather Display
//               weatherProvider.isLoading
//                   ? const CircularProgressIndicator()
//                   : weatherProvider.weatherData == null
//                       ? const Text(
//                           'Search for a city to get weather updates',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white),
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.location_on,
//                                 size: 40, color: Colors.redAccent),
//                             Text(weatherProvider.weatherData!.city,
//                                 style: const TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white)),
//                             const SizedBox(height: 10),
//                             const Icon(Icons.thermostat,
//                                 size: 50, color: Colors.orange),
//                             Text(
//                                 '${weatherProvider.weatherData!.temperature}°C',
//                                 style: const TextStyle(
//                                     fontSize: 50,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white)),
//                             const SizedBox(height: 10),
//                             const SizedBox(height: 20),
//
//                             // View Details Button
//                             ElevatedButton.icon(
//                               onPressed: () async {
//                                 await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => DetailScreen()),
//                                 );
//                                 loadSavedCities(); // Reload saved cities after returning from details
//                               },
//                               icon: const Icon(Icons.info, size: 20),
//                               label: const Text('View Details'),
//                               style: ElevatedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             ),
//                           ],
//                         ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
