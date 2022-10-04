import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
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

  @override
  void initState() {
    // getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[700],
              ),
              child: const Text(
                'Breathalyzer',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ),
            ),
            ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    noteRoute,
                    (route) => false,
                  );
                }),
            ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    profileRoute,
                    (route) => false,
                  );
                }),
            ListTile(
              title: const Text('Test Result'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  testResultRoute,
                  (route) => false,
                );
              },
            ),
            // ListTile(
            //   title: const Text('History'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
                title: const Text('Pairing'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    pairRoute,
                    (route) => false,
                  );
                }),
          ],
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal[900],
        ),
        elevation: 0,
        backgroundColor: Colors.teal[900],
        title: const Text('Test Result'),
        titleTextStyle: GoogleFonts.lobster(fontSize: 25),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //*Breathing Indicator
            SizedBox(
              height: 230,
              width: 230,
              child: LiquidCircularProgressIndicator(
                value: 0.25, // Defaults to 0.5.
                valueColor: const AlwaysStoppedAnimation(Colors
                    .deepOrangeAccent), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.grey[500],
                borderWidth: 5.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                center: const Text("Loading..."),
              ),
            ),
            Container(
              height: 50, //this is added as a spacer bwt map and indicator.
            ),
            //* Google Map view.
            SizedBox(
              height: 300,
              width: 500,
              child: GoogleMap(
                // ignore: prefer_const_constructors
                initialCameraPosition: CameraPosition(
                  target: setLocation,
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  addMarker('test', setLocation);
                },
                markers: _markers.values.toSet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addMarker(String id, LatLng location) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/beerIcon1.png',
    );

    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: 'Your Current location',
        snippet: setLocation.toString(),
      ),
      icon: markerIcon,
    );

    _markers[id] = marker;
    setState(() {});
  }
}




















//!-------------------------------------------------------------------------------
              // final Completer<GoogleMapController> _controller = Completer();
  // var location = Location();
  // bool? serviceEnabled;
  // PermissionStatus? _permissionGranted;
  // LocationData? locationData;
  // LocationData? currentLocation;

  // void getCurrentLocation() async {
  //   var serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   await location.getLocation().then((location) {
  //     currentLocation = location;
  //     print(location);
  //   });
  // }
              
//!-------------------------------------------------------------------------------          
              // child: currentLocation == null
              //     ? const Text(
              //         'Loading',
              //         style: TextStyle(fontSize: 16),
              //         textAlign: TextAlign.center,
              //       )
              //     : GoogleMap(
              //         compassEnabled: false,
              //         mapToolbarEnabled: false,
              //         zoomControlsEnabled: false,
              //         initialCameraPosition: const CameraPosition(
              //           target: setLocation,
              //           // LatLng(
              //           //   currentLocation!.latitude!,
              //           //   currentLocation!.longitude!,
              //           // ),
              //           zoom: 15,
              //         ),
              //         markers: {
              //             // Marker(
              //             //   markerId: const MarkerId('CurrentLocation'),
              //             //   position:
              //             //   LatLng(
              //             //     currentLocation!.latitude!,
              //             //     currentLocation!.longitude!,
              //             //   ),
              //             // ),
              //             //This is for testing only
              //             const Marker(
              //               markerId: MarkerId('SetLocation'),
              //               position: setLocation,
              //             ),
              //           }),