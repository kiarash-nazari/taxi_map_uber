import 'package:flutter/material.dart';
import 'package:taxi_map/constants/Text_Styles.dart';
import 'package:taxi_map/widgets/back_button_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MappScreenState();
}

class _MappScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        //OSM MAP
        Container(
          color: Colors.black,
        ),

        //Origin button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              "Select Origin",
              style: MyTextStyles.button,
            ),
          ),
        ),

        MyBackButton(
          onpressed: () {
            print("ss");
          },
        ),
      ]),
    ));
  }
}
