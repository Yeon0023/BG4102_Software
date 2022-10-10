import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceConnectionStatus extends StatelessWidget {
  const DeviceConnectionStatus({Key? key, required this.device})
      : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: double.infinity,
      width: 200,
      // color: Colors.grey,
      //* Checking connection state of connected device.
      child: Column(
        children: [
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) => ListTile(
              leading: (snapshot.data == BluetoothDeviceState.connected)
                  ? const Icon(Icons.bluetooth_connected, color: Colors.blue)
                  : const Icon(Icons.bluetooth_disabled, color: Colors.red),
              trailing: Text(snapshot.data.toString().split('.')[1]),
            ),
          ),
        ],
      ),
    );
  }
}
