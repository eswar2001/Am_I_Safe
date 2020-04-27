import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';

import 'location.dart';

class FetchData extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: GetData(),
    );
  }
}

class GetData extends StatefulWidget {
  Location a;
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
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
                  locationData("Speed: " + speed)
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

  getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print("This is current Location" + location.longitude.toString());
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
