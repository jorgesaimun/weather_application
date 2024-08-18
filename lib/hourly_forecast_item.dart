import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temparature;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temparature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
         // width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "$temparature°C",
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}
