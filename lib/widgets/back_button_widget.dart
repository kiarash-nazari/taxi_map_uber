import 'package:flutter/material.dart';
import 'package:taxi_map/constants/Dimens.dart';

class MyBackButton extends StatelessWidget {
  Function() onpressed;

  MyBackButton({super.key, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: Dimens.medium,
      top: Dimens.medium,
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(2, 3), blurRadius: 18),
          ],
        ),
        child: IconButton(
            onPressed: onpressed,
            icon: const Icon(
              Icons.arrow_back,
            )),
      ),
    );
  }
}
