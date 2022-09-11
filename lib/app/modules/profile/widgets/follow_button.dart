import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color bgColor;
  final Color borderColor;
  final String textButton;
  final Color textColor;

  FollowButton(
      {Key? key,
      this.onTap,
      required this.bgColor,
      required this.borderColor,
      required this.textButton,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width,
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 3,
      ),
      child: TextButton(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            textButton,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: Get.size.width,
        ),
      ),
    );
  }
}
