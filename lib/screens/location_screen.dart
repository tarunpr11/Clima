import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({required this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = new WeatherModel();
  double? temp;
  String? weatherIcon;
  String? cityName;
  int? temperature;
  String? weatherMessage;
  Widget body = SpinKitFoldingCube(
    color: Colors.white,
    size: 100.0,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic locationWeather) async {
    if (locationWeather == null) {
      setState(() {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
      });
      return;
    }
    dynamic weatherData = await locationWeather;
    temp = await weatherData['main']['temp'];
    var condition = await weatherData['weather'][0]['id'];
    String? name = await weatherData['name'];
    print(temp);
    setState(() {
      temperature = temp!.toInt();
      weatherMessage = weather.getMessage(temperature!);
      weatherIcon = weather.getWeatherIcon(condition!);
      cityName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      dynamic weatherData =
                          await WeatherModel().getLocationWeather();
                      setState(() {
                        updateUI(weatherData);
                      });
                      print('Pressed');
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(),
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
