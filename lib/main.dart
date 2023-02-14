import 'package:flutter/material.dart';
import 'package:taxi_map/Map_Screen.dart';
import 'package:taxi_map/constants/Dimens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MapScreen(),
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              fixedSize: const MaterialStatePropertyAll(
                Size(double.infinity, 58),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.medium),
                ),
              ),
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color.fromARGB(255, 150, 238, 96);
                }

                return const Color.fromARGB(255, 2, 207, 36);
              })),
        ),
      ),
    );
  }
}
