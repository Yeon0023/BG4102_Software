import 'dart:async';
import 'package:bg4102_software/Utilities/currentAddress.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/Utilities/utils.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
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
  var location = Location();
  static const String startTestUuid = "0x2A57";
  static const String retrieveResultUuid = "0x8594";
  late GoogleMapController _mapController;
  // ignore: non_constant_identifier_names
  double BAC = 0.0; //!BAC is Blood Alcohol Content.
  // ignore: prefer_final_fields, unused_field
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
  TwilioFlutter? twilioFlutter;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = '';
  String ec = '';
  String ecp = '';
  get value => readData(startTestCharacteristic!);

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC4594fe0673b475bd0dbee2770e2f8eda',
        authToken: 'dc32274542c684524eb629b6cf8a40df',
        twilioNumber: '+13854062421');
    _getPermission();
    _getCurrentLocation();
    super.initState();
    _getdata();
  }

  //?--------------------------------THIS IS SMS SYSTEM----------------------------------------------------------------
  //Firebase Cloud
  void _getdata() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        name = userData.data()!['Name'];
        ec = userData.data()!['Emergency Contact'];
        ecp = userData.data()!['Emergency contact person'];
      });
    });
  }

  // String ec = '+6590292936';
  // String name = 'Yeo Nigel';
  // String ecp = 'Yee Guan';
  Future<void> _sendSms(String Address) async {
    twilioFlutter?.sendSMS(
        toNumber: ec,
        messageBody:
            'Hi $ecp, $name is drunk currently. Please come and get $name at $Address.');
  }

  //?-----------------------------------This is BlueTooth Section.------------------------------------------------------
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
  //?-------------------------------------------------------------------------------------------------------------------

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
  Future<void> _getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) async {
        currentLocation = location;
        List<double> currentCoordinate = [];
        currentCoordinate
            .addAll([currentLocation!.latitude!, currentLocation!.longitude!]);
        await GetCurrentAddress(currentCoordinate);
        // await _sendSms(Address); //!This is for testing only.
        if (!mounted) return;
        setState(() {});
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
    if (!mounted) return;
    setState(() {});
  }

  //* Draw Google Map on page.
  Widget _drawGoogleMap() => Container(
        height: SizeConfig.blockSizeVertical * 40,
        width: SizeConfig.blockSizeHorizontal * 100,
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

  final double _testValue = 0.7;
  //*Alcohol level Indicator
  Widget _drawIndicator() => SizedBox(
        height: 230,
        width: 230,
        child: LiquidCircularProgressIndicator(
          value: BAC, // Defaults to 0.5.
          // value: _testValue, //!Testing
          valueColor: AlwaysStoppedAnimation(
            BAC >= 0.8
                ? Colors.red
                : BAC > 0.2 && BAC < 0.8
                    ? Colors.orange
                    : Colors.green,
          ), // Defaults to the current Theme's accentColor.
          backgroundColor:
              Colors.white, // Defaults to the current Theme's backgroundColor.
          borderColor: Colors.grey[500],
          borderWidth: 5.0,
          direction: Axis
              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
          center: Text(
            _indicatorText,
            // _testValue.toString(),
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

              //! For Testing only.
              // BAC = 0.09;
              // Timer(const Duration(seconds: 3), () {
              //   resultDialog(BAC);
              // });

              int data = 1;
              await startTest(data);
              List<int> result = await readData(startTestCharacteristic!);
              setState(() {
                _indicatorText = "Loading...";
              });
              if (result.first == 1) {
                List<int> result =
                    await readData(retrieveResultCharacteristic!);
                // ignore: no_leading_underscores_for_local_identifiers
                double _value = convertByteArray(result);
                BAC =
                    relativeToAlcohol(_value); //!BAC is Blood Alcohol Content.
                _indicatorText = _value.toString();
                Timer(const Duration(seconds: 3), () {
                  resultDialog(BAC);
                });
                if (!mounted) return;
                setState(() {});
              } else {
                print("Error, try again...");
              }
            },
          ),
        ),
      );

  //* BAC level from: https://beta.mountelizabeth.com.sg/healthplus/article/festive-drinking-driving
  String drinkingstatus = '';
  String dialogContent = '';
  // ignore: non_constant_identifier_names
  void resultDialog(BAC) {
    if (BAC >= 0.08) {
      drinkingstatus = "Drinking Status: Drunk";
      dialogContent =
          "\n\nPLEASE DO NOT DRIVE ! \n\nBreathX have contacted your emergency contact about your location.";
      _sendSms(Address);
    } else if (BAC > 0.02 && BAC < 0.08) {
      drinkingstatus = "Drinking status: Within limit";
      dialogContent =
          "\n\nYou are within limit, Ensure you are Sober by playing a GAME to test your focus.";
    } else {
      drinkingstatus = "Drinking Status: Sober";
      dialogContent = "\n\nYou are Sober, reward yourself by playing a GAME!";
    }
    var now = DateTime.now();
    var formatter = DateFormat('\ndd-MM-yyyy – HH:mm');
    final String formattedDate = formatter.format(now);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("BreathX Result"),
        content: Text(
          '$drinkingstatus $dialogContent \n\nDate & Time of Record: $formattedDate',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          BAC < 0.08
              ? TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pushNamed(gamePageRoute);
                  },
                  child: Container(
                    color: Colors.teal[500],
                    padding: const EdgeInsets.all(14),
                    child: const Text("Play Game"),
                  ),
                )
              : Container(),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.teal[500],
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

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
    SizeConfig().init(context);
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
              height: SizeConfig.blockSizeVertical * 85,
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

//!-------------------------------------END----------------------------------------------------------------------------
