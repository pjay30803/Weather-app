import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_scapper_app/provider/internet_provider.dart';
import 'package:sky_scapper_app/provider/theme_provider.dart';
import 'package:sky_scapper_app/provider/weather_provider.dart';
import 'package:sky_scapper_app/views.screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => Internetprovider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sky Scrapper',
            theme: themeProvider.getTheme(),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
