import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
String url = "http://127.0.0.1:5000/";


//function to toggle TE
Future<Map<String,String>> toggleTE(Map<String, String> input) async {
  Map<String,String> returnResults = new Map();
  final request = http.MultipartRequest(
    "POST", Uri.parse(url + "togglete"),
  );
  String decodeInput = json.encode(input);
  request.fields['inputTE'] = decodeInput;

  //try to send the request
  try {
    var resp = await request.send();
    //read response
    String results = await resp.stream.bytesToString();
    final decoded = json.decode(results);
    returnResults['results'] = decoded['results'];
    returnResults['details'] = decoded['details'];
  }
  on Exception  {
    returnResults['results'] = 'fail';
    returnResults['details'] = 'Unable to Connect to server';
  }
  return Future.value(returnResults);
}


//function to toggle difference
Future<Map<String,String>> togglediscretize() async {
  Map<String,String> returnResults = new Map();
  final request = http.MultipartRequest(
    "POST", Uri.parse(url + "togglediscretize"),
  );

  //try to send the request
  try {
    var resp = await request.send();
    //read response
    String results = await resp.stream.bytesToString();
    final decoded = json.decode(results);

    returnResults['results'] = decoded['results'];
    returnResults['details'] = decoded['details'];
  }
  on Exception  {
    returnResults['results'] = 'fail';
    returnResults['details'] = 'Unable to Connect to server';
  }
  return Future.value(returnResults);
}

Future<Map<String,String>> runStationarity(String johSig, String adfSig) async {
  Map<String,String> returnResults = new Map();
  final request = http.MultipartRequest(
    "POST", Uri.parse(url + "runstationarity"),
  );
  request.fields['johSig'] = johSig;
  request.fields['adfSig'] = adfSig;
  //try to send the request
  try {
    var resp = await request.send();
    //read response
    String results = await resp.stream.bytesToString();
    final decoded = json.decode(results);
    returnResults['results'] = decoded['results'];
    returnResults['details'] = decoded['details'];
  }
  on Exception {
    returnResults['results'] = 'fail';
    returnResults['details'] = 'Unable to Connect to server';
  }
  return Future.value(returnResults);
}

//function to toggle difference
Future<Map<String,String>> toggledifference() async {
  Map<String,String> returnResults = new Map();
  final request = http.MultipartRequest(
    "POST", Uri.parse(url + "toggledifference"),
  );
  //try to send the request
  try {
    var resp = await request.send();
    //read response
    String results = await resp.stream.bytesToString();
    final decoded = json.decode(results);

    returnResults['results'] = decoded['results'];
    returnResults['details'] = decoded['details'];
  }
  on Exception {
    returnResults['results'] = 'fail';
    returnResults['details'] = 'Unable to Connect to server';
  }
  return Future.value(returnResults);
}

//function to upload CSV
Future<Map<String,String>> uploadSelectedFile() async {
    //this will be the return return for the function
    Map<String,String> returnResults = new Map();

    PlatformFile objFile = null;
    //file picker for the file, csv allowed only
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withReadStream: true, // this will return PlatformFile object with read stream
    );

    //assign and sent only if result is not null
    if (result != null) {
        objFile = result.files.single;

        //generate a new request
        final request = http.MultipartRequest(
          "POST", Uri.parse(url + "uploadCSV"),
        );
        //add the csv file to the request
        request.files.add(new http.MultipartFile(
            "CSVFileUpload", objFile.readStream, objFile.size,
            filename: objFile.name));

        //try to send the request
        try {
          var resp = await request.send();
          //read response
          String results = await resp.stream.bytesToString();
          final decoded = json.decode(results);

          returnResults['results'] = decoded['results'];
          returnResults['details'] = decoded['details'];
        }
        on Exception {
          returnResults['results'] = 'fail';
          returnResults['details'] = 'Unable to Connect to server';
        }
    }
    //nothing is selected!
    else{
      returnResults['results'] = 'fail';
      returnResults['details'] = 'No file selected';
    }
    return Future.value(returnResults);
}