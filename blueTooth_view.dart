// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';


// class BlueToothView extends StatefulWidget {
//   const BlueToothView({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _BlueToothViewState createState() => _BlueToothViewState();
// }

// class _Message {
//   int whom;
//   String text;

//   _Message(this.whom, this.text);
// }

// class _BlueToothViewState extends State<BlueToothView> with SingleTickerProviderStateMixin {
//   final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   final firebaseUser = FirebaseAuth.instance.currentUser;
//   BluetoothConnection? connection;
//   BluetoothDevice? mydevice;
//   String op = '';
//   bool isConnectButtonEnabled = true;
//   bool isDisConnectButtonEnabled = false;
//   bool showResults=false;
//   double? bac;
//   String? baclevel;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   String name = '';
//   String ec = '';
//   String fp = '';
//   double? tts;
//   int? color;
//   String centreText = 'Welcome Back';
//   String tts1 = 'Time to Sobriety: ';
//   String Address = '';
//   String _messageBuffer = '';
//   String dataString = '';
//   String warmcentreText = '';
//   String blowcentreText = '';

//   AnimationController? _animationController;
//   Animation? tween;
//   Color myColor = Colors.blue;
//   String drinkingstatus = 'Drinking Status: ';

//   List<_Message> messages = List<_Message>.empty(growable: true);

//   RegExp exp = RegExp(r'(\w+)');
//   RegExp checksec = RegExp(r'^[0-9]+\ss$');
//   RegExp checksec2 = RegExp(r'^[0-9]+\sss$');
//   // ignore: non_constant_identifier_names
//   RegExp re_bac = RegExp(r'^([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?$');
//   // ignore: prefer_typing_uninitialized_variables
//   var matchedText;
//   // ignore: prefer_typing_uninitialized_variables
//   var matchdText2;
//   late Iterable<Match> matches;
//   late Iterable<Match> matches2;


//   void _connect() async {
//     List<BluetoothDevice> devices = [];
//     setState(() {
//       isConnectButtonEnabled = false;
//       isDisConnectButtonEnabled = true;
//     });
//     Fluttertoast.showToast(
//       msg: 'Pairing',
//       backgroundColor: Colors.grey,
//       textColor: Colors.white,
//       fontSize: 16,
//     );
//     devices = await _bluetooth.getBondedDevices();
//     // ignore: unnecessary_statements
//     for (var device in devices) {
//       print(device);
//       if (device.name == "Manoject Nano 33 IoT") {
//         mydevice = device;
//         Fluttertoast.showToast(
//           msg: 'Connected',
//           backgroundColor: Colors.lightGreenAccent,
//           textColor: Colors.white,
//           fontSize: 16,
//         );
//       }
//     }

//     await BluetoothConnection.toAddress(mydevice?.address).then((connection) async {
//       print('Connected to the device' + mydevice.toString());
//       connection = connection;
//     });
//     connection!.input!.listen(_onDataReceived).onDone((){});
//     connection!.input!.listen(null).onDone(() {
//       print('Disconnected remotely!');
//     });
//   }

//   void _sendMessage(String text) async {

//     connection?.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
//     await connection?.output.allSent;
//   }

//   Future<void> _disconnect() async {
//     _sendMessage('0');
//     setState(() {
//       op = "Disconnected";
//       isConnectButtonEnabled = true;
//       isDisConnectButtonEnabled = false;
//     });
//     connection?.close();
//     connection?.dispose();
//     Fluttertoast.showToast(
//       msg: 'Disconnected',
//       backgroundColor: Colors.grey,
//       textColor: Colors.white,
//       fontSize: 16,
//     );
//   }

//   Future<void> _onDataReceived(Uint8List data) async {
//     _sendMessage('1');
//     // Allocate buffer for parsed data
//     int backspacesCounter = 0;
//     for (var byte in data) {
//       if (byte == 8 || byte == 127) {
//         backspacesCounter++;
//       }
//     }
//     Uint8List buffer = Uint8List(data.length - backspacesCounter);
//     int bufferIndex = buffer.length;

//     // Apply backspace control character
//     backspacesCounter = 0;
//     for (int i = data.length - 1; i >= 0; i--) {
//       if (data[i] == 8 || data[i] == 127) {
//         backspacesCounter++;
//       } else {
//         if (backspacesCounter > 0) {
//           backspacesCounter--;
//         } else {
//           buffer[--bufferIndex] = data[i];
//         }
//       }
//     }

//     // Create message if there is new line character
//     //String dataString = String.fromCharCodes(buffer);
//     dataString = String.fromCharCodes(buffer);
//     int index = buffer.indexOf(13);
//     if (~index != 0) {
//       setState(() {
//         messages.add(
//           _Message(
//             1,
//             backspacesCounter > 0
//                 ? _messageBuffer.substring(
//                 0, _messageBuffer.length - backspacesCounter)
//                 : _messageBuffer + dataString.substring(0, index),
//           ),
//         );
//         _messageBuffer = dataString.substring(index);
//       });
//     } else {
//       _messageBuffer = (backspacesCounter > 0
//           ? _messageBuffer.substring(
//           0, _messageBuffer.length - backspacesCounter)
//           : _messageBuffer + dataString);
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     final List<Row> list = messages.map((message) {
//       return Row(
//         children: <Widget>[
//           Text((text) {
//             return text == '/shrug' ? '¯\\_(ツ)_/¯' : op = text; //
//           }(message.text.trim()),),
//         ],
//       );
//     }).toList();

//     if (checksec.hasMatch(op) == true) { //detect s from '20 s' data
//       matches = exp.allMatches(op);
//       matchedText = matches.elementAt(0).group(0); //parse the '10' from '10s'
//       var warmcountdown = int.parse(matchedText);
//       warmcentreText = ('Warming up ' '$matchedText');
//       centreText = warmcentreText;
//       myColor = Colors.blue;
//       _animationController?.animateTo(1);
//       _animationController?.duration = const Duration(seconds: 15);
//       if (warmcountdown == 0) {
//         _animationController?.value = 0;
//       }
//       if (warmcountdown == 20) {
//         drinkingstatus = '';
//         tts1 = '';
//       }
//     }
//     else if (re_bac.hasMatch(op) == true) {
//       print(const Text("result shown here"));
//     }
//     else if (checksec2.hasMatch(op) == true) { //detect ss from '10 ss'
//       matches2 = exp.allMatches(op);
//       matchedText = matches2.elementAt(0).group(0); //parse the '10' from '10s'
//       var blowountdown = int.parse(matchedText);
//       blowcentreText = ('Blow for ' '$matchedText');
//       centreText = blowcentreText;
//       myColor = Colors.blue;
//       _animationController?.animateTo(1);
//       _animationController?.duration = const Duration(seconds: 10);
//       if (blowountdown == 0) {
//         _animationController?.value = 0;
//       }
//     }
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         label: const Text('Help'),
//         onPressed: () async {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text("How to get started"),
//                 content: const Text(
//                     '1. Switch on the DrinkÉ device.' '\n\n' '2. Connect to it.' '\n\n' '3. Press the warm up button.' '\n\n'+ '4. Start blowing for 10 sec!'
//                     , maxLines: 200),
//                 actions: <Widget>[
//                   ElevatedButton(
//                     child: const Text("OK"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//       appBar: AppBar(
//         title: const Text('Drinké Breathalyser'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Visibility(
//                 visible: isConnectButtonEnabled,
//                 child:
//                 Container(
//                     padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                     child: ElevatedButton.icon(
//                         label: const Text('Connect'),
//                         icon: const Icon(Icons.bluetooth_rounded),
//                         onPressed: isConnectButtonEnabled ? _connect : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.greenAccent,
//                           fixedSize: const Size (150,20),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50)),
//                         )
//                     )
//                 ),
//               ),
//               Visibility(
//                 visible: isDisConnectButtonEnabled,
//                 child:
//                 Container(
//                     padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                     child: ElevatedButton.icon(
//                         label: const Text('Disconnect'),
//                         icon: const Icon(Icons.bluetooth_disabled_rounded),
//                         onPressed: isDisConnectButtonEnabled ? _disconnect : null,
//                           //1. pop up msg ask to reset on device
//                           //2. run void() to refresh this page
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.redAccent,
//                           fixedSize: const Size (150,20),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50)),
//                         )
//                     )
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             margin: const EdgeInsets.fromLTRB(20, 30, 0, 0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(drinkingstatus, style: const TextStyle(fontSize: 20,
//                 fontWeight: FontWeight.bold,),),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.fromLTRB(20, 30, 0, 0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(tts1, style: const TextStyle(fontSize: 20,
//                 fontWeight: FontWeight.bold,),),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }