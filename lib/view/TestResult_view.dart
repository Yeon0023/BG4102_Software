import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:bg4102_software/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

const LatLng setLocation = LatLng(1.342834, 103.681757);

class TestResultView extends StatefulWidget {
  const TestResultView({Key? key}) : super(key: key);

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  final Map<String, Marker> _markers = {};

  var location = Location();
  bool? serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  LocationData? currentLocation;

  @override
  void initState() {
    _getCurrentLocation();
    _drawGoogleMap();
    super.initState();
  }

  //*Get the current location of device in lat and long.
  void _getCurrentLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then((location) {
      currentLocation = location;
      print(currentLocation);
    });
  }

  //* Draw Google Map on page.
  Widget _drawGoogleMap() => SizedBox(
        height: 340,
        width: double.infinity,
        child: currentLocation == null
            ? const Text(
                'Loading',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )
            : GoogleMap(
                // ignore: prefer_const_constructors
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  addMarker(
                    'Current Location',
                    LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                  );
                },
                markers: _markers.values.toSet(),
              ),
      );

  //* Add marker on the map.
  addMarker(String id, LatLng location) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/beerIcon65.png',
    );

    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: 'Your Current location',
        snippet: LatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        ).toString(),
      ),
      icon: markerIcon,
    );

    _markers[id] = marker;
    setState(() {});
  }

  //*Alcohol level Indicator
  Widget _drawIndicator() => SizedBox(
        height: 230,
        width: 230,
        child: LiquidCircularProgressIndicator(
          value: 0.25, // Defaults to 0.5.
          valueColor: const AlwaysStoppedAnimation(Colors
              .deepOrangeAccent), // Defaults to the current Theme's accentColor.
          backgroundColor:
              Colors.white, // Defaults to the current Theme's backgroundColor.
          borderColor: Colors.grey[500],
          borderWidth: 5.0,
          direction: Axis
              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: const Text(
            "Loading...",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );

  //*Final View of Test Result page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const customDrawer(),
      appBar: const customAppbar(
        title: 'Test Result',
        fontSize: 25,
        actions: null,
        leading: null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _drawIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.amber[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: Text(
                    'Check Alcohol Level',
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "Your Alcolhol Level For Today is 10%",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.blue[900],
                        textColor: Colors.white,
                        fontSize: 17);
                  },
                ),
              ),
            ),
            _drawGoogleMap()
          ],
        ),
      ),
    );
  }
}
