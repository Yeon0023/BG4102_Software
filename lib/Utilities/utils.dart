import 'dart:math';
import 'dart:typed_data';

double convertByteArray(List<int>? read) {
  if (read!.isEmpty) {
    return 0;
  } else {
    return double.parse(
        Uint8List.fromList(read).buffer.asFloat32List()[0].toStringAsFixed(3));
  }
}

double relativeToAlcohol(double level) {
  // 0, 0.08
  return min(level * 12.5, 1);
}
