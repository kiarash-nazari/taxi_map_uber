import 'package:flutter/material.dart';
import 'package:taxi_map/constants/Dimens.dart';
import 'package:taxi_map/constants/Text_Styles.dart';

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
        Container(
          color: Colors.black,
        ),
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
        Positioned(
          left: Dimens.medium,
          top: Dimens.medium,
          child: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 3),
                    blurRadius: 18),
              ],
            ),
            child: IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          ),
        ),
      ]),
    ));
  }
}
