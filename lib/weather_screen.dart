import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/aditional_info_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/hourly_forecast_item.dart';
import 'package:weather_application/secreats.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "El Paso"; // Default city name
  late Future<Map<String, dynamic>> weather;
  late Future<Map<String, dynamic>> hourlyforecast;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cityController.text = cityName;
    weather = getCurrentWeather();
    hourlyforecast = getHourlyForecast();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != 200) {
        throw "An unexpected error occurred: ${data['message']}";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> getHourlyForecast() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw "An unexpected error occurred: ${data['message']}";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  void updateWeather() {
    setState(() {
      cityName = _cityController.text;
      weather = getCurrentWeather();
      hourlyforecast = getHourlyForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: updateWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: "Enter City Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon:const Icon(Icons.search),
                    onPressed: updateWeather,
                  ),
                ),
                onSubmitted: (value) => updateWeather(),
              ),
              const SizedBox(height: 15),
              FutureBuilder<Map<String, dynamic>>(
                future: weather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final data = snapshot.data!;
                  final currTempK = data['main']['temp'];
                  final currTempC =
                      currTempK - 273.15; // Convert Kelvin to Celsius
                  final currSky = data['weather'][0]['main'];
                  final currHumidity = data['main']['humidity'];
                  final currPressure = data['main']['pressure'];
                  final currWind = data['wind']['speed'];

                  return Column(
                    children: [
                      // Card with current weather info
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${currTempC.toStringAsFixed(1)}°C",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      currSky == 'Rain' || currSky == 'Clouds'
                                          ? Icons.cloud
                                          : Icons.sunny,
                                      size: 100,
                                    ),
                                    Text(
                                      currSky,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Hourly forecast",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<Map<String, dynamic>>(
                        future: hourlyforecast,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          final hourlyData = snapshot.data!['list'] as List;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var forecast in hourlyData.take(8)) ...[
                                  HourlyForecastItem(
                                    time: DateFormat.j().format(
                                        DateTime.parse(forecast['dt_txt'])),
                                    temparature:
                                        (forecast['main']['temp'] - 273.15)
                                            .toStringAsFixed(1),
                                    icon: forecast['weather'][0]['main'] ==
                                                'Rain' ||
                                            forecast['weather'][0]['main'] ==
                                                'Clouds'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Additional information
                      const Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AditionalInfoItem(
                            icon: Icons.water_drop,
                            label: "Humidity",
                            info: currHumidity.toString(),
                          ),
                          AditionalInfoItem(
                            icon: Icons.air,
                            label: "Wind Speed",
                            info: currWind.toString(),
                          ),
                          AditionalInfoItem(
                            icon: Icons.beach_access,
                            label: "Pressure",
                            info: currPressure.toString(),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
