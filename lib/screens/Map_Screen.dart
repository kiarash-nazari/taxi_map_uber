import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
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
  Widget markerIcon = SvgPicture.asset(
    "assets/icons/origin.svg",
    height: 100,
    width: 40,
  );
  Widget originIcon = SvgPicture.asset(
    "assets/icons/origin.svg",
    height: 100,
    width: 40,
  );
  Widget destIcon = SvgPicture.asset(
    "assets/icons/destination.svg",
    height: 100,
    width: 40,
  );
  List<GeoPoint> geoPoints = [];
  String distance = "calculating distance...";
  String originAddress = "Origin Adrress...";
  String distanceAdrress = "Distance Adrress...";

  MapController mapController = MapController(initMapWithUserPosition: true);
  // initPosition: GeoPoint(latitude: 34.8505739, longitude: 33.4233499));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        //OSM MAP
        SizedBox.expand(
          child: OSMFlutter(
            controller: mapController,
            trackMyPosition: false,
            initZoom: 15,
            maxZoomLevel: 18,
            minZoomLevel: 8,
            isPicker: true,
            stepZoom: 1.0,
            mapIsLoading: const SpinKitCircle(
              color: Color.fromARGB(255, 25, 130, 222),
              size: 50.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 100,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
            ),
            roadConfiguration: RoadConfiguration(
                roadColor: const Color.fromARGB(255, 10, 149, 242),
                startIcon: const MarkerIcon(
                    icon: Icon(
                  Icons.cyclone_rounded,
                ))),
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
            if (geoPoints.isNotEmpty) {
              geoPoints.removeLast();
            }
            setState(() {
              if (currentWidgetList.length > 1) {
                currentWidgetList.removeLast();
                markerIcon = SvgPicture.asset(
                  "assets/icons/origin.svg",
                  height: 100,
                  width: 40,
                );
                mapController.init();
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

  Widget origin() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () async {
            GeoPoint originGeoPoint =
                await mapController.getCurrentPositionAdvancedPositionPicker();

            geoPoints.add(originGeoPoint);

            markerIcon = destIcon;

            setState(() {
              currentWidgetList
                  .add(CurrentWidgetState.selectedDestinationState);
            });
            mapController.cancelAdvancedPositionPicker();

            await mapController.addMarker(geoPoints.first,
                markerIcon: MarkerIcon(
                  iconWidget: originIcon,
                ));
            mapController.init();
          },
          child: Text(
            "Select Origin",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }

  Widget des() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () async {
            await mapController
                .getCurrentPositionAdvancedPositionPicker()
                .then((value) {
              geoPoints.add(value);
            });

            mapController.cancelAdvancedPositionPicker();
            await mapController.addMarker(geoPoints.last,
                markerIcon: MarkerIcon(
                  iconWidget: destIcon,
                ));

            await distance2point(geoPoints.first, geoPoints.last).then((value) {
              if (value <= 1000) {
                distance =
                    "distance is ${value.toStringAsFixed(2).toString()} M";
              } else {
                distance =
                    "distance is ${(value / 1000).toStringAsFixed(2).toString()} KM";
              }
            });
            setState(() {
              currentWidgetList
                  .add(CurrentWidgetState.selectedRequestDriverState);
            });
            getExactAdrress();
          },
          child: Text(
            "Select Destination",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }

  Widget reqDriver() {
    mapController.zoomOut();
    mapController.currentLocation();
    mapController.drawRoad(geoPoints.first, geoPoints.last,
        roadOption: const RoadOption(
            keepInitialGeoPoints: true,
            roadWidth: 9,
            zoomInto: true,
            showMarkerOfPOI: true,
            roadColor: Colors.blue));

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.medium),
                ),
                child: Center(child: Text(originAddress))),
            const SizedBox(
              height: Dimens.small,
            ),
            Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.medium),
                ),
                child: Center(child: Text(distanceAdrress))),
            const SizedBox(
              height: Dimens.small,
            ),
            Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.medium),
                ),
                child: Center(child: Text(distance))),
            const SizedBox(
              height: Dimens.small,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Request Driver",
                  style: MyTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getExactAdrress() async {
    try {
      await placemarkFromCoordinates(
              geoPoints.first.latitude, geoPoints.first.longitude,
              localeIdentifier: "en")
          .then((List<Placemark> pList) {
        setState(() {
          originAddress =
              "${pList.first.locality} ${pList.first.street} ${pList.first.thoroughfare} ${pList[2].name}";
        });
      });
      await placemarkFromCoordinates(
              geoPoints.last.latitude, geoPoints.last.longitude,
              localeIdentifier: "en")
          .then((List<Placemark> pList) {
        setState(() {
          distanceAdrress =
              "${pList.first.locality} ${pList.first.street} ${pList.first.thoroughfare} ${pList[2].name}";
        });
      });
    } catch (e) {
      originAddress = "adrress is not availible";
      distanceAdrress = "adrress is not availible";
    }
  }
}
