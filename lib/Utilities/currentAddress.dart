import 'package:geocoding/geocoding.dart';

// ignore: non_constant_identifier_names
String Address = '';

// ignore: non_constant_identifier_names
GetCurrentAddress(List<double> currentCoordinate) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
      currentCoordinate[0], currentCoordinate[1]);
  // print(placemarks);
  Placemark place = placemarks[0];
  Address =
      '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
}
