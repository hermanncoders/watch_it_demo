import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'json/weather_in_cities.dart';

class WeatherManager {
  ValueListenable<List<WeatherEntry>> get weatherEntries => _weatherEntries;
  ValueListenable<bool> get isRunning => _isRunning;

  final _weatherEntries = ValueNotifier<List<WeatherEntry>>([]);
  final _isRunning = ValueNotifier<bool>(false);

  WeatherManager() {
    update("");
  }

  void onTextChanged(String? text) {
    update(text);
  }

  // Async function that queries the REST API and converts the result into the form our ListViewBuilder can consume
  Future<void> update(String? filtertext) async {
    _isRunning.value = true;

    const url =
        "https://api.openweathermap.org/data/2.5/box/city?bbox=12,32,15,37,10&appid=27ac337102cc4931c24ba0b50aca6bbd";

    var httpStream =
        http.get(Uri.parse(url)).timeout(const Duration(seconds: 5)).asStream();

    _weatherEntries.value = await httpStream
        .where(
            (data) => data.statusCode == 200) // only continue if valid response
        .map(
      (data) {
        // convert JSON result into a List of WeatherEntries
        return WeatherInCities.fromJson(
                json.decode(data.body) as Map<String, dynamic>)
            .cities // we are only interested in the Cities part of the response
            .where((weatherInCity) =>
                filtertext == null ||
                filtertext
                    .isEmpty || // if filtertext is null or empty we return all returned entries
                weatherInCity.name.toUpperCase().startsWith(filtertext
                    .toUpperCase())) // otherwise only matching entries
            .map((weatherInCity) => WeatherEntry(
                weatherInCity)) // Convert City object to WeatherEntry
            .toList(); // aggregate entries to a List
      },
    ).first; // Return result as Future

    _isRunning.value = false;
  }
}

class WeatherEntry {
  late String cityName;
  String? iconURL;
  late double wind;
  late double rain;
  late double temperature;
  String? description;

  WeatherEntry(City city) {
    this.cityName = city.name;
    this.iconURL = city.weather[0].icon != null
        ? "https://openweathermap.org/img/w/${city.weather[0].icon}.png"
        : null;
    this.description = city.weather[0].description;
    this.wind = city.wind.speed.toDouble();
    this.rain = city.rain;
    this.temperature = city.main.temp;
  }
}
