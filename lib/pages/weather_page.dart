import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import '../models/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('9a68d3ee49fb0323a848748fd51e5b0e');
  Weather?  _weather;

  _fetchWeather() async{
    final cityName = await _weatherService.getCityName();
    try{
         final weather = await _weatherService.getWeather(cityName);
         setState((){
           _weather = weather;
         });
    }catch(e){
      print(e);
    }
  }
  String getWeatherAnimation(String?mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition) {
      case 'shower rain':
        return 'assets/rainy.json';
      case 'fog':
        return 'assets/cloudy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json'; 
      default:
        return 'assets/sunny.json';  
    }
  }
  @override
  void initState(){
    super.initState();
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App'),),
      floatingActionButton: FloatingActionButton(onPressed: _fetchWeather,child: const Icon(Icons.location_on),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.fromARGB(255, 137, 194, 222),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName??'Loading City Name ....' ,style: const TextStyle(fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
            decorationStyle: TextDecorationStyle.dotted,
            fontStyle: FontStyle.italic,
            letterSpacing: 2,
            wordSpacing: 2,
            height: 1,
            overflow: TextOverflow.ellipsis,
            shadows: [
              Shadow(color: Colors.black,offset: Offset(2, 2),blurRadius: 2),
            ],
            decorationThickness: 2,),),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition),width: 200,height: 200),
            Text('${_weather?.temp.round()} ℃' ,style: const TextStyle(fontSize: 20,
                color:Colors.amber,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ) ),
          ],
          ),
      )
     
    );
  }
}
