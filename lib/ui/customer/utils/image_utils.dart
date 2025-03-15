import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source); // Await the result properly

  if (_file != null) {
    return await _file.readAsBytes(); // Convert XFile to Uint8List
  }

  print('No Image Selected');
  return null; // Explicitly return null if no image is selected
}
