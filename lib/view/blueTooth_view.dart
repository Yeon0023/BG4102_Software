import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlueToothView extends StatelessWidget {
  const BlueToothView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
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
              stream: FlutterBlue.instance.scanResults,
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
                        subtitle: Text(result.device.id.toString()),
                        //* This is the connection state indicator.
                        trailing: StreamBuilder<BluetoothDeviceState>(
                          stream: result.device.state,
                          initialData: BluetoothDeviceState.connecting,
                          builder: (c, snapshot) => Text(
                              'Device is ${snapshot.data.toString().split('.')[1]}.'),
                        ),
                        onTap: () {
                          //* This is the pop up dialog.
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

      //* This the search bluetooth buttom bottom right corner.
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () => FlutterBlue.instance.startScan(
                timeout: const Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }
}
