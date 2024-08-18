import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home:const WeatherScreen());
  }
}
 

 // hourly forecast  :: https://api.openweathermap.org/data/2.5/forecast?q=Dhaka&appid=b374620219dd4504b1e50cce80d7bb68