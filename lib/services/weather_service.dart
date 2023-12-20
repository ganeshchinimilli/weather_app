import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;
  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apikey&units=metric'));
    // print the response in console
    print(jsonDecode(response.body));
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather for $cityName');
    }
  }

  Future<String> getCityName() async {

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    };
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    List<Placemark> placement = await placemarkFromCoordinates(position.latitude, position.longitude);
    
    String? city = placement[0].locality;
    return city??'';
  }
}