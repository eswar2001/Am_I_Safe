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

   String latitude = "waiting...";
   String longitude = "waiting...";
   String altitude = "waiting...";
   String accuracy = "waiting...";
   String bearing = "waiting...";
   String speed = "waiting...";

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
              locationData("Latitude: " + latitude),
              locationData("Longitude: " + longitude),
              locationData("Altitude: " + altitude),
              locationData("Accuracy: " + accuracy),
              locationData("Bearing: " + bearing),
              locationData("Speed: " + speed),
              RaisedButton(
                  onPressed: () {
                    BackgroundLocation.startLocationService();
                  },
                  child: Text("Start Location Service")),
              RaisedButton(
                  onPressed: () {
                    BackgroundLocation.stopLocationService();
                  },
                  child: Text("Stop Location Service")),
              RaisedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: Text("Get Current Location")),
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
