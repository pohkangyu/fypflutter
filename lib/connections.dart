import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bottomTab.dart' as bottomTab;
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
Future<Map<String,String>> uploadSelectedFile(String urlExtension) async {
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
          "POST", Uri.parse(url + urlExtension),
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


Future<Map<String,String>> uploadSettingsFile(String urlExtension) async {

  //this will be the return return for the function
  Map<String,String> returnResults = new Map();

  PlatformFile objFile = null;
  //file picker for the file, csv allowed only
  var result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  //assign and sent only if result is not null
  if (result != null) {

    PlatformFile selectedFile = result.files.first;
    Map<String, String> parsed = selectParseCSV(selectedFile);

    List<String> controllers = ["max_lag_sources", "min_lag_sources", "max_lag_target", "tau_sources",
      "tau_target", "n_perm_max_stat", "n_perm_min_stat", "n_perm_omnibus",
      "n_perm_max_seq", "alpha_max_stats", "alpha_min_stats", "alpha_omnibus"];

    List<TextEditingController> toEdit = [
      bottomTab.max_lag_sourceController,
      bottomTab.min_lag_sourceController,
      bottomTab.max_lag_targetController,
      bottomTab.tau_sourcesController,
      bottomTab.tau_targetController,
      bottomTab.n_perm_max_statController,
      bottomTab.n_perm_min_statController,
      bottomTab.n_perm_omnibusController,
      bottomTab.n_perm_max_seqController,
      bottomTab.alpha_max_statsController,
      bottomTab.alpha_min_statsController,
      bottomTab.alpha_omnibusController,
    ];

    for (int i = 0; i < controllers.length; i++){
      if (parsed.containsKey(controllers[i])){
        toEdit[i].text = parsed[controllers[i]];
      }
    }
    returnResults['results'] = 'pass';
    returnResults['details'] = 'Success';
  }
  //nothing is selected!
  else{
    returnResults['results'] = 'fail';
    returnResults['details'] = 'No file selected';
  }
  return Future.value(returnResults);
}

Map<String, String> selectParseCSV(PlatformFile selectedFile)  {
  String s = new String.fromCharCodes(selectedFile.bytes);
  Map<String, String> ret = {};
  s.split('\n').forEach((element) {
      if (element.contains(",")) {
        List<String> temp = element.split(",");
        if (temp[1].length > 1){
          ret[temp[0]] = temp[1];
        }
        }
      }
      );
  return ret;
}

