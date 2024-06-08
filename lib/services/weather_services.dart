import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_main_mitchkoko/models/weather_model.dart';

class WeatherServices{
  static const Base_Url = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse("$Base_Url?q=$cityName&appid=$apiKey&units=metric"));

    if(response.statusCode==200){
      log(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async{
    //get permission from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    //convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from the first placemark
    String? city =placemarks[0].locality;
    print(city);

    return city ?? "";
  }
}


