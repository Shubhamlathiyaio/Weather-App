import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/models/environment.dart';
import 'package:weather_app/resources/constents.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _city = "Ahmedabad";

  Future<Environment> fetchWeather(String city) async {
    final response = await Dio().get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        "q": city,
        "appid": API_KEY,
        "units": "metric"
      },
    );
    return Environment.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: "Enter city name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _city = _cityController.text;
                    });
                  },
                  child: Icon(Icons.search),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Environment>(
                future: fetchWeather(_city),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching weather"));
                  } else {
                    final data = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _city,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          Icons.wb_sunny,
                          size: 80,
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${data.main?.temp}°C",
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.weather?[0].description ?? "",
                          style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.opacity, color: Colors.blue),
                                Text("Humidity"),
                                Text("${data.main?.humidity}%"),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.air, color: Colors.green),
                                Text("Wind Speed"),
                                Text("${data.wind?.speed} m/s"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}