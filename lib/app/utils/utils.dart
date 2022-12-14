import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? file = await _imagePicker.pickImage(source: imageSource);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('nothing image');
}
