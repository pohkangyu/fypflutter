import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


upload() async {
  InputElement uploadInput = FileUploadInputElement();
  uploadInput.accept = ".csv";
  uploadInput.multiple = false;
  uploadInput.click();
  uploadInput.onChange.listen((event) {
    final files = uploadInput.files;

    if (files.length == 1) {
      final file = files[0];
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        print('loaded: ${file.name}');
        print('type: ${reader.result.runtimeType}');
        print('file size = ${file.size}');
      }
      );
    }
  });
}

void uploadSelectedFile(File objFile) async {
  //---Create http package multipart request object
  final request = http.MultipartRequest(
    "POST",
    Uri.parse("Your API URL"),
  );
  //-----add other fields if needed
  request.fields["id"] = "abc";

  //-----add selected file with request
  request.files.add(http.MultipartFile.fromBytes(
      'ImagePaths',
      objFile,
      filename: 'some-file-name.jpg',
      contentType: MediaType("file", "csv"),
    )
  );

  //-------Send request
  var resp = await request.send();

  //------Read response
  String result = await resp.stream.bytesToString();

  //-------Your response
  print(result);
}