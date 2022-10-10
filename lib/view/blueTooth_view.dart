import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/view/TestResult_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../Utilities/BlueTooth_connection.dart';
import '../Utilities/Bluetooth_data.dart';
import '../Utilities/customAppbar.dart';

bool isDeviceConnected = false;

class BlueToothView extends StatelessWidget {
  const BlueToothView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);
  final BluetoothState? state;

  //* This is show if bluetooth an device is On/Off.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.red,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
            ),
          ],
        ),
      ),
    );
  }
}

void _blueToothConnectionPopUp(context, result) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('BlueTooth Connection'),
        content:
            const Text('Are you sure you want to connect with this device?'),
        actions: [
          TextButton(
            onPressed: () {
              // result.device.connect();
              Navigator.of(context).pop(result.device.connect());
              isDeviceConnected = true;
            },
            child: const Text('Connect'),
          ),
          TextButton(
            onPressed: () {
              // result.device.disconnect();
              Navigator.of(context).pop(result.device.disconnect());
            },
            child: const Text('Disconnect'),
          ),
        ],
      );
    },
  );
}

List selectedDevice = [];

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title: 'Find Devices',
        fontSize: 25,
        actions: null,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //* This to a list view of all bluetooth device detected.
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.instance.scanResults,
              initialData: const [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map(
                      (result) => ListTile(
                        title: Text(
                          result.device.name == ""
                              ? "No Name"
                              : result.device.name,
                        ),
                        //* The Name of selected device.
                        subtitle: Text(result.device.id.toString()),
                        //* Blue tooth connection state indicator.
                        trailing: DeviceConnectionStatus(device: result.device),
                        onTap: () {
                          //* This is the pop up dialog.
                          selectedDevice.add(result.device);
                          _blueToothConnectionPopUp(context, result);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),

      //* Search bluetooth button, bottom right corner.
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBluePlus.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () => FlutterBluePlus.instance.startScan(
                timeout: const Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }
}







//!---------------------------------------------------------------------------------------------
// class DeviceScreen extends StatelessWidget {
//   const DeviceScreen({Key? key, required this.device}) : super(key: key);

//   final BluetoothDevice device;

  // List<Widget> _buildServiceTiles(List<BluetoothService> services) {
  //   List<BluetoothService> copy = [];

  //   for (BluetoothService service in services) {
  //     if ("0x${service.uuid.toString().toUpperCase().substring(4, 8)}" ==
  //         "0x180A") {
  //       copy.add(service);
  //     }
  //   }
  //   return copy
  //       .map(
  //         (s) => ServiceTile(
  //           service: s,
  //           characteristicTiles: s.characteristics
  //               .map(
  //                 (c) => CharacteristicTile(
  //                   characteristic: c,
  //                   onReadPressed: () => c.read(),
  //                   onWritePressed: () async {
  //                     await c.write(
  //                         [1]); //! Start Case 1 in adriuno and start test.
  //                     await c.read();
  //                   },
  //                   onNotificationPressed: () async {
  //                     await c.setNotifyValue(!c.isNotifying);
  //                     await c.read();
  //                   },
  //                   descriptorTiles: c.descriptors
  //                       .map(
  //                         (d) => DescriptorTile(
  //                           descriptor: d,
  //                           onReadPressed: () => d.read(),
  //                           onWritePressed: () => d.write([0]),
  //                         ),
  //                       )
  //                       .toList(),
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       )
  //       .toList();
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(device.name),
//         actions: <Widget>[
//           StreamBuilder<BluetoothDeviceState>(
//             stream: device.state,
//             initialData: BluetoothDeviceState.connecting,
//             builder: (c, snapshot) {
//               VoidCallback? onPressed;
//               String text;
//               switch (snapshot.data) {
//                 case BluetoothDeviceState.connected:
//                   onPressed = () => device.disconnect();
//                   text = 'DISCONNECT';
//                   break;
//                 case BluetoothDeviceState.disconnected:
//                   onPressed = () => device.connect();
//                   text = 'CONNECT';
//                   break;
//                 default:
//                   onPressed = null;
//                   text = snapshot.data.toString().substring(21).toUpperCase();
//                   break;
//               }
//               return TextButton(
//                   onPressed: onPressed,
//                   child: Text(
//                     text,
//                     style: Theme.of(context)
//                         .primaryTextTheme
//                         .button
//                         ?.copyWith(color: Colors.white),
//                   ));
//             },
//           )
//         ],
//       ),
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
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Colors.grey),
//                           ),
//                           width: 18.0,
//                           height: 18.0,
//                         ),
//                         onPressed: null,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
            // StreamBuilder<List<BluetoothService>>(
            //   stream: device.services,
            //   initialData: const [],
            //   builder: (c, snapshot) {
            //     return Column(
            //       children: _buildServiceTiles(snapshot.data!),
            //     );
            //   },
            // ),
//           ],
//         ),
//       ),
//     );
//   }
// }