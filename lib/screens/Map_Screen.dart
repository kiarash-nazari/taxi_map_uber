import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taxi_map/constants/Dimens.dart';
import 'package:taxi_map/constants/Text_Styles.dart';
import 'package:taxi_map/widgets/back_button_widget.dart';

class CurrentWidgetState {
  CurrentWidgetState._();
  static const selectedOriginState = 0;
  static const selectedDestinationState = 1;
  static const selectedRequestDriverState = 2;
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MappScreenState();
}

class _MappScreenState extends State<MapScreen> {
  List currentWidgetList = [CurrentWidgetState.selectedOriginState];
  Widget markerIcon = SvgPicture.asset("icons/origins.svg");
  List<GeoPoint> geoPoints = [];

  MapController mapController = MapController(
      initMapWithUserPosition: false,
      initPosition:
          GeoPoint(latitude: 35.3254642654, longitude: 90.2355842345));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        //OSM MAP
        SizedBox.expand(
          child: OSMFlutter(
            controller: mapController,
            initZoom: 15,
            maxZoomLevel: 18,
            minZoomLevel: 8,
            isPicker: true,
            stepZoom: 1,
            mapIsLoading: const SpinKitCircle(
              color: Colors.black,
            ),
            markerOption: MarkerOption(
              advancedPickerMarker: MarkerIcon(
                iconWidget: markerIcon,
              ),
            ),
          ),
        ),

        //Origin button
        currentWidget(),

        MyBackButton(
          onpressed: () {
            setState(() {
              if (currentWidgetList.length > 1) {
                currentWidgetList.removeLast();
              }
            });
          },
        ),
      ]),
    ));
  }

  Widget currentWidget() {
    Widget widget = origin();

    switch (currentWidgetList.last) {
      case CurrentWidgetState.selectedOriginState:
        widget = origin();
        break;
      case CurrentWidgetState.selectedDestinationState:
        widget = des();
        break;
      case CurrentWidgetState.selectedRequestDriverState:
        widget = reqDriver();
        break;
    }
    return widget;
  }

  Positioned origin() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              currentWidgetList
                  .add(CurrentWidgetState.selectedDestinationState);
            });
          },
          child: Text(
            "Select Origin",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }

  Positioned des() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              currentWidgetList
                  .add(CurrentWidgetState.selectedRequestDriverState);
            });
          },
          child: Text(
            "Select Destination",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }

  Positioned reqDriver() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            "Request Driver",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }
}
