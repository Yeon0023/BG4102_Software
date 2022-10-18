import 'dart:async';
import 'package:bg4102_software/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import '../Utilities/customAppbar.dart';
import '../Utilities/customDrawer.dart';

class TestResultView extends StatefulWidget {
  const TestResultView({Key? key}) : super(key: key);

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  final LatLng _initialcameraposition = const LatLng(20.5937, 78.9629);
  final Map<String, Marker> _markers = {};
  final String serviceUuid = "0x180A";
  final String bleFloat = "C8F88594-2217-0CA6-8F06-A4270B675D69";
  final String targetDeviceName = "ManoBreathalyser";
  final Location _location = Location();
  static const String startTestUuid = "0x2A57";
  static const String retrieveResultUuid = "0x8594";
  late GoogleMapController _mapController;
  var location = Location();
  double _result = 0.0;
  String _indicatorText = "No Result";
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  StreamSubscription<ScanResult>? scanSubcription;
  bool? serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  LocationData? currentLocation;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? startTestCharacteristic,
      retrieveResultCharacteristic;
  BluetoothDescriptor? targetDescriptor;
  String connectionText = "";

  get value => readData(startTestCharacteristic!);

  @override
  void initState() {
    _getPermission();
    _getCurrentLocation();
    super.initState();
  }

  //*-----------------------------------This is Blue Tooth Section. ------------------------------------------------

  startScan() {
    setState(() {
      connectionText = "Start Scanning";
    });

    scanSubcription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == targetDeviceName) {
        print('DEVICE found');
        stopScan();
        setState(() {
          connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    scanSubcription?.cancel();
    scanSubcription = null;
  }

  bool _connected = false;
  connectToDevice() async {
    if (targetDevice == null) return;
    setState(() {
      connectionText = "Device Connecting";
    });
    await targetDevice!.connect().then(
          (value) => _connected = true,
        );

    print('DEVICE CONNECTED');
    setState(() {
      connectionText = "Device Connected";
    });
    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;
    targetDevice?.disconnect();
    setState(
      () {
        connectionText = "Device Disconnected";
      },
    );
  }

  bool _isBlueToothConnected = false;
  toggleBlueTooth() {
    if (_isBlueToothConnected == true) {
      disconnectFromDevice();
    } else {
      startScan();
      connectToDevice();
    }
    setState(() {
      _isBlueToothConnected = !_isBlueToothConnected;
    });
  }

  discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice!.discoverServices();
    // ignore: avoid_function_literals_in_foreach_calls
    services.forEach(
      (service) {
        if ('0x${service.uuid.toString().toUpperCase().substring(4, 8)}' ==
            serviceUuid) {
          // ignore: avoid_function_literals_in_foreach_calls
          service.characteristics.forEach(
            (characteristic) {
              switch (
                  "0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}") {
                case startTestUuid:
                  startTestCharacteristic = characteristic;
                  break;
                case retrieveResultUuid:
                  retrieveResultCharacteristic = characteristic;
                  break;
                default:
              }
            },
          );
        }
      },
    );
  }

  startTest(int data) async {
    if (startTestCharacteristic == null) return;
    await startTestCharacteristic!.write([data]);
  }

  Future<List<int>> readData(BluetoothCharacteristic characteristic) async {
    return await characteristic.read();
  }

  //*-------------------------------------------------------------------------------------------------------------------

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
          value: _result, // Defaults to 0.5.
          valueColor: const AlwaysStoppedAnimation(Colors
              .deepOrangeAccent), // Defaults to the current Theme's accentColor.
          backgroundColor:
              Colors.white, // Defaults to the current Theme's backgroundColor.
          borderColor: Colors.grey[500],
          borderWidth: 5.0,
          direction: Axis
              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: Text(
            _indicatorText,
            style: const TextStyle(color: Colors.black),
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
            onPressed: () async {
              await Fluttertoast.showToast(
                msg: "Starting Test Now !",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue[900],
                textColor: Colors.white,
                fontSize: 17,
              );

              int data = 1;
              await startTest(data);
              List<int> result = await readData(startTestCharacteristic!);
              setState(() {
                _indicatorText = "Loading...";
              });
              if (result.first == 1) {
                List<int> result =
                    await readData(retrieveResultCharacteristic!);
                double _value = convertByteArray(result);
                _result = relativeToAlcohol(_value);
                _indicatorText = _value.toString();
                setState(() {});
              } else {
                print("Error, try again...");
              }
            },
          ),
        ),
      );

  //* BlueTooth Connection.
  final connectedText = const Text.rich(
    TextSpan(
      children: [
        WidgetSpan(child: Icon(Icons.bluetooth_connected)),
        TextSpan(
            text: ' Connected',
            style: TextStyle(
              fontSize: 18,
            )),
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
        width: 180,
        height: 50,
        child: ElevatedButton(
          // ignore: unrelated_type_equality_checks
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: _connected ? Colors.blue[700] : Colors.red[700],
          ),
          onPressed: () {
            toggleBlueTooth();
          },
          child: _connected ? connectedText : disconnectedText,
        ),
      );

  //*Final View of Test Result page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const customDrawer(),
      appBar: const CustomAppbar(
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

  @override
  void dispose() {
    super.dispose();
    _drawGoogleMap();
  }
}


//!---------------------------------------------------------------------------------------------------------------------

