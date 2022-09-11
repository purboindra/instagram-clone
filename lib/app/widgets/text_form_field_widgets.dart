import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/app/modules/login/controllers/login_controller.dart';

class TextFormFieldWidgets extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;

  const TextFormFieldWidgets({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.isPass,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
