import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<Map<String, dynamic>>> getWeatherForecast(String regionName) async {
  const apiKey = '7fd341202df385e3b1ac9a4a98e7f9a5';
  final apiUrl = 'https://api.openweathermap.org/data/2.5/forecast?q=$regionName&appid=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> forecasts = [];


    for (var forecast in data['list']) {
      String dateTime = forecast['dt_txt'];

      double tempCelsius = forecast['main']['temp'] - 273.15;
      double rainProbability = forecast['pop'].toDouble() * 100;

      forecasts.add({
        'dateTime': dateTime,
        'temperature': tempCelsius,
        'rainProbability': rainProbability,
      });
    }

    return forecasts;
  } else {
    return [];
  }
}
