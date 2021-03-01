import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// variable to hold image to be displayed
Map<String,String> failMessage = {'results' : 'fail', 'text' : 'text'};
Future<Map<String,String>>  runStationarity(String adfSig, String johSig) async {
  final request = http.MultipartRequest(
    "POST",
    Uri.parse("http://127.0.0.1:5000/"),
  );

  request.fields["runTest"] = "runTest";
  request.fields["adfSig"] = adfSig;
  request.fields["johSig"] = johSig;
  var resp = await request.send();
  String results = await resp.stream.bytesToString();
  final decoded = json.decode(results);
  Map<String,String> returnResults = new Map();
  returnResults['results'] = decoded['results'];
  returnResults['details'] =  decoded['details'];
  returnResults['text'] =  decoded['text'];
  return Future.value(returnResults);
}

Future<Map<String,String>> uploadSelectedFile() async {
  PlatformFile objFile = null;
  var result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
    withReadStream: true, // this will return PlatformFile object with read stream
  );

  if (result != null) {
      objFile = result.files.single;
  }
  //---Create http package multipart request object
  final request = http.MultipartRequest(
    "POST",
    Uri.parse("http://127.0.0.1:5000/"),
  );
  //request.fields["id"] = "abc";

  //-----add selected file with request
  request.files.add(new http.MultipartFile(
      "CSVFileUpload", objFile.readStream, objFile.size,
      filename: objFile.name));

  try {
    var resp = await request.send();
  }
  on Exception {
    failMessage['text'] = 'Unable to Connect to server';
    return Future.value(failMessage);
  }
  var resp = await request.send();

  //------Read response
  String results = await resp.stream.bytesToString();

  //-------Your response
  //final body = json.decode(results);
  Map<String,String> returnResults = new Map();

  final decoded = json.decode(results);
  print(decoded['results']);
  returnResults['results'] = decoded['results'];
  returnResults['text'] = objFile.name;
  return Future.value(returnResults);

}