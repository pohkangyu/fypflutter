import 'dart:io';



import 'package:file_picker/file_picker.dart';
import 'dart:io';

abstract class FileDirectionary {
  // some generic methods to be exposed.
  /// returns a value based on the key
  Future<String> getPath() async {

  }
}

class WebFile implements FileDirectionary {
  @override
  Future<String> getPath() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();


    if(result != null) {
    } else {
      // User canceled the picker
    }
  }

}