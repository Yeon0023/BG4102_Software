import 'package:bg4102_software/view/blueTooth_view.dart';
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
        height: 300,
        width: 400,
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
          height: 55,
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
                msg: "Starting Test Now !",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue[900],
                textColor: Colors.white,
                fontSize: 17,
              );
            },
          ),
        ),
      );

  final connectedText = const Text.rich(
    TextSpan(
      children: [
        WidgetSpan(child: Icon(Icons.bluetooth_connected)),
        TextSpan(text: ' Connected', style: TextStyle(fontSize: 18)),
      ],
    ),
  );

  final disconnectedText = const Text.rich(
    TextSpan(
      children: [
        WidgetSpan(child: Icon(Icons.bluetooth_disabled)),
        TextSpan(text: ' Disconnected', style: TextStyle(fontSize: 18)),
      ],
    ),
  );

  Widget _status() => Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color:
              isDeviceConnected == false ? Colors.red[900] : Colors.blue[900],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isDeviceConnected == false ? disconnectedText : connectedText,
          ],
        ),
        // child: isDeviceConnected == false ? disconnectedText : connectedText,
      );

  //*Final View of Test Result page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            Container(
              height: 710,
              // color: Colors.blue,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 10,
                    child: _status(),
                  ),
                  Positioned(
                    top: 85,
                    child: _drawIndicator(),
                  ),
                  Positioned(
                    bottom: 0,
                    child: _drawGoogleMap(),
                  ),
                  Positioned(
                    top: 320,
                    child: _toastmaker(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}







//!---------------------------------------------------------------------------------------------------------------------

// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;

//   const ServiceTile(
//       {Key? key, required this.service, required this.characteristicTiles})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.isNotEmpty) {
//       return ExpansionTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Text('Service'),
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                     color: Theme.of(context).textTheme.caption?.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return ListTile(
//         title: const Text('Service'),
//         subtitle:
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }

// class CharacteristicTile extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback? onReadPressed;
//   final VoidCallback? onWritePressed;
//   final VoidCallback? onNotificationPressed;

//   const CharacteristicTile(
//       {Key? key,
//       required this.characteristic,
//       required this.descriptorTiles,
//       this.onReadPressed,
//       this.onWritePressed,
//       this.onNotificationPressed})
//       : super(key: key);

//   String _convertByteArray(List<int>? read) {
//     if (read!.isEmpty) {
//       return "0";
//     } else {
//       if (read.length == 1) {
//         return "1";
//       } else {
//         var bytes = Uint8List.fromList(read);
//         return bytes.buffer.asFloat32List()[0].toStringAsFixed(3);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<int>>(
//       stream: characteristic.value,
//       initialData: characteristic.lastValue,
//       builder: (c, snapshot) {
//         final value = snapshot.data;
//         return ExpansionTile(
//           title: ListTile(
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 const Text('Characteristic'),
//                 Text(
//                     '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//                     style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                         color: Theme.of(context).textTheme.caption?.color))
//               ],
//             ),
//             subtitle: Text(
//               _convertByteArray(value),
//               style: const TextStyle(color: Colors.red),
//             ),
//             contentPadding: const EdgeInsets.all(0.0),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//                 ),
//                 onPressed: onReadPressed,
//               ),
//               IconButton(
//                 icon: Icon(Icons.file_upload,
//                     color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
//                 onPressed: onWritePressed,
//               ),
//               IconButton(
//                 icon: Icon(
//                     characteristic.isNotifying
//                         ? Icons.sync_disabled
//                         : Icons.sync,
//                     color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
//                 onPressed: onNotificationPressed,
//               )
//             ],
//           ),
//           children: descriptorTiles,
//         );
//       },
//     );
//   }
// }

// class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback? onReadPressed;
//   final VoidCallback? onWritePressed;

//   const DescriptorTile(
//       {Key? key,
//       required this.descriptor,
//       this.onReadPressed,
//       this.onWritePressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const Text('Descriptor'),
//           Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyText1
//                   ?.copyWith(color: Theme.of(context).textTheme.caption?.color))
//         ],
//       ),
//       subtitle: StreamBuilder<List<int>>(
//         stream: descriptor.value,
//         initialData: descriptor.lastValue,
//         builder: (c, snapshot) => Text(snapshot.data.toString()),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }

// //!---------------------------------------------------------------------------------------------------------------------

// class DeviceScreen extends StatelessWidget {
//   const DeviceScreen({Key? key, required this.device}) : super(key: key);

//   final BluetoothDevice device;

//   List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//     List<BluetoothService> copy = [];
//     for (BluetoothService service in services) {
//       if ("0x${service.uuid.toString().toUpperCase().substring(4, 8)}" ==
//           "0x180A") {
//         copy.add(service);
//       }
//     }
//     return copy
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map(
//                   (c) => CharacteristicTile(
//                     characteristic: c,
//                     onReadPressed: () => c.read(),
//                     onWritePressed: () async {
//                       await c.write([1]);
//                       await c.read();
//                     },
//                     onNotificationPressed: () async {
//                       await c.setNotifyValue(!c.isNotifying);
//                       await c.read();
//                     },
//                     descriptorTiles: c.descriptors
//                         .map(
//                           (d) => DescriptorTile(
//                             descriptor: d,
//                             onReadPressed: () => d.read(),
//                             onWritePressed: () => d.write([0]),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 )
//                 .toList(),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(device.name)),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             StreamBuilder<BluetoothDeviceState>(
//               stream: device.state,
//               initialData: BluetoothDeviceState.connecting,
//               builder: (c, snapshot) => ListTile(
//                 leading: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     snapshot.data == BluetoothDeviceState.connected
//                         ? const Icon(Icons.bluetooth_connected)
//                         : const Icon(Icons.bluetooth_disabled),
//                   ],
//                 ),
//                 title: Text(
//                     'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                 subtitle: Text('${device.id}'),
//                 trailing: StreamBuilder<bool>(
//                   stream: device.isDiscoveringServices,
//                   initialData: false,
//                   builder: (c, snapshot) => IndexedStack(
//                     index: snapshot.data! ? 1 : 0,
//                     children: <Widget>[
//                       IconButton(
//                         icon: const Icon(Icons.refresh),
//                         onPressed: () => device.discoverServices(),
//                       ),
//                       const IconButton(
//                         icon: SizedBox(
//                           width: 18.0,
//                           height: 18.0,
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Colors.grey),
//                           ),
//                         ),
//                         onPressed: null,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             StreamBuilder<List<BluetoothService>>(
//               stream: device.services,
//               initialData: const [],
//               builder: (c, snapshot) {
//                 return Column(
//                   children: _buildServiceTiles(snapshot.data!),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//!---------------------------------------------------------------------------------------------------------------------
