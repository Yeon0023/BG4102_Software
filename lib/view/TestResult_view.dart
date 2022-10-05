import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:bg4102_software/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
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
      print(location);
    });
  }

  





  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

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
                center: const Text(
                  "Loading...",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              height: 50, //this is added as a spacer bwt map and indicator.
            ),
            //* Google Map view.
            SizedBox(
              height: 400,
              width: 500,
              child: currentLocation == null ? 
                  
                  // const GoogleMap(
                  //     initialCameraPosition: CameraPosition(
                  //       target: setLocation,
                  //       zoom: 15,
                  //     ),
                  //   )
                  const Text(
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
            ),
          ],
        ),
      ),
    );
  }

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
}

























//!-------------------------------------------------------------------------------
  // final Completer<GoogleMapController> _controller = Completer();

              
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





/*Determine the current position of the device.When the location services are not enabled or permission 
// are denied the `Future` will return an error.*/
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     // Permissions are denied forever, handle appropriately.
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }