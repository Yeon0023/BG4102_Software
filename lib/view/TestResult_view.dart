import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:bg4102_software/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class TestResultView extends StatefulWidget {
  const TestResultView({Key? key}) : super(key: key);

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  final LatLng _initialcameraposition = const LatLng(20.5937, 78.9629);
  final Map<String, Marker> _markers = {};
  var location = Location();
  late GoogleMapController _mapController;
  final Location _location = Location();
  bool? serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  LocationData? currentLocation;

  @override
  void initState() {
    _getPermission();
    _getCurrentLocation();
    super.initState();
  }

  //*Get the current location of device in lat and long.
  void _getPermission() async {
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
  }

  //* Get current Location for Icon only.
  void _getCurrentLocation() {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
  }

  //* Get current Location for camera position.
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15,
          ),
        ),
      );
      addMarker(
        'Current Location',
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
      );
    });
  }

  //* Add marker on the map.
  addMarker(String id, LatLng currentLocation) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/beerIcon65.png',
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: currentLocation,
      infoWindow: InfoWindow(
        title: 'Your Current location',
        snippet: LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ).toString(),
      ),
      icon: markerIcon,
    );
    _markers[id] = marker;
    setState(() {});
  }

  //* Draw Google Map on page.
  Widget _drawGoogleMap() => Container(
        height: 340,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueGrey,
            width: 1.5,
          ),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: _initialcameraposition),
          onMapCreated: _onMapCreated,
          markers: _markers.values.toSet(),
        ),
      );

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

  //* This is to activate the process of recoding the test.
  Widget _toastmaker() => Padding(
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
                msg: "Your Alcohol Level For Today: 10%",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue[900],
                textColor: Colors.white,
                fontSize: 17,
              );
            },
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
            _toastmaker(),
            _drawGoogleMap(),
          ],
        ),
      ),
    );
  }
}

//!----------------------------------------------------------------------------------------
