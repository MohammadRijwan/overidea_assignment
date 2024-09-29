import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:overidea_assignment/src/core/utils/app_constant.dart';
import 'package:overidea_assignment/src/core/utils/app_locale.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static String route = 'map_screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocale.mapScreen.getString(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * (AppConstant.isWeb ? 0.2 : 0.0)),
          child: OpenStreetMapSearchAndPick(
            locationPinIconColor: Colors.red,
            buttonTextStyle:
                const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
            buttonColor: Colors.blue,
            buttonText: 'Set Current Location',
            onPicked: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
              print(pickedData.addressName);
            },
          ),
        ));
  }
}
