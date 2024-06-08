import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_main_mitchkoko/models/weather_model.dart';
import 'package:weather_app_main_mitchkoko/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String cityName = 'Nagpur';
  //apiKey
  final _weatherServices = WeatherServices("cc3b433c5e483e3ea54704c09bee2f89");
  model? _model;
  var weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
     cityName = await _weatherServices.getCurrentCity();
      log(cityName);
    //get weather for city
       weather= await _weatherServices.getWeather(cityName);
       _model = weather;
     setState(() {
     });
  }

  //weather animations
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(future: _fetchWeather(), builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
//city name
                  Text(cityName,style: TextStyle(color: Colors.red,fontSize: 40),),
                  Text("${_model!.main!.temp!.toDouble()}"),
//temperature
// Text("${_weather!.temperature.toString()} C")
                ],
              );
            }
            else if(snapshot.hasError){
              return Center(child: Text(snapshot.hasError.toString()));;
            }
            else{
              return Container();
            }
          }
          else{
            return CircularProgressIndicator();
          }

        },),
      ),
    );
  }
}



