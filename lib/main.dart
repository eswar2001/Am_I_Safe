import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

String text = 'User1';
void main() {
  runApp(FetchData());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FetchData(),
    );
  }
}

class FetchData extends StatefulWidget {
  _FetchDataState createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress = "Hang in there";
  String latitude = "Hang in there";
  String longitude = "Hang in there";
  String altitude = "Hang in there";
  String accuracy = "Hang in there";
  String bearing = "Hang in there";
  String speed = "Hang in there";

  @override
  void initState() {
    super.initState();
    BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      setState(() {
        this.latitude = location.latitude.toString();
        this.longitude = location.longitude.toString();
        this.accuracy = location.accuracy.toString();
        this.altitude = location.altitude.toString();
        this.bearing = location.bearing.toString();
        this.speed = location.speed.toString();
      });

      print("""\n
      Latitude:  $latitude
      Longitude: $longitude
      Altitude: $altitude
      Accuracy: $accuracy
      Bearing:  $bearing
      Speed: $speed
      """);
    });

    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  locationData("Latitude: " + latitude),
                  locationData("Longitude: " + longitude),
                  locationData("Altitude: " + altitude),
                  locationData("Accuracy: " + accuracy),
                  locationData("Bearing: " + bearing),
                  locationData("Speed: " + speed),
                  locationData("Location: " + _currentAddress),
                ],
              ),
              SizedBox(
                height: 100.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: () {
                          BackgroundLocation.startLocationService();
                        },
                        tooltip: 'Start Location Service',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.location_off),
                        onPressed: () {
                          BackgroundLocation.stopLocationService();
                        },
                        tooltip: "Stop Location Service",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        onPressed: () {
                          getCurrentLocation();
                        },
                        tooltip: "Get Current Location",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
    BackgroundLocation().getCurrentLocation().then(
      (location) {
        print("This is current Location" + location.longitude.toString());
        var timeStamp = DateTime.now();
        http.put(
            "https://amisafe-706fd.firebaseio.com/$text/$timeStamp/latitude",
            body: json.encode(latitude));
        http.put(
            "https://amisafe-706fd.firebaseio.com/$text/$timeStamp/longitude",
            body: json.encode(longitude));
      },
    );
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
