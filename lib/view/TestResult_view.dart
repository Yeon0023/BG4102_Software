import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TestResultView extends StatefulWidget {
  const TestResultView({Key? key}) : super(key: key);

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  // final Completer<GoogleMapController> _controller = Completer();
  // static const LatLng setLocation = LatLng(1.342834, 103.681757);
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
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
            // ignore: sized_box_for_whitespace
            Container(
              height: 380,
              width: 500,
              child: currentLocation == null
                  ? const Text(
                      'Loading',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  : GoogleMap(
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        ),
                        zoom: 15,
                      ),
                      markers: {
                          Marker(
                            markerId: const MarkerId('CurrentLocation'),
                            position: LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            ),
                          ),
                          //This is for testing only
                          // const Marker(
                          //   markerId: MarkerId('SetLocation'),
                          //   position: setLocation,
                          // ),
                        }),
            ),
          ],
        ),
      ),
    );
  }
}
