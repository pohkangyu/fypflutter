import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgetFactory.dart';
import 'connections.dart';
List<String> tabsName = ["Upload Data", "First Difference", "Upload Settings", "Stationarity Test", "Discretize Values"];
String pathdirectoryCSV = "Select Path To Upload";
String pathdirectorySettingsUpload = "Select Path To Upload";
String pathdirectorySettingsDownload = "Download File";
String stationaryState = "Pass!";
String discretizedState = "Pass!";
Map<String, double> significant = { "1%": 0.01, "5%": 0.05,  "10%": 0.1 };
List<DropdownMenuItem<String>> adf_significant_items = [
  generateDropDownMenuItem('1%'),
  generateDropDownMenuItem('5%'),
  generateDropDownMenuItem('10%'),
];
List<DropdownMenuItem<String>> joh_significant_items = [
  generateDropDownMenuItem('1%'),
  generateDropDownMenuItem('5%'),
  generateDropDownMenuItem('10%'),
];

String johSig = '1%';
String adfSig = '1%';

//state of the specification of the top tabs
class TopTab extends StatefulWidget {
  @override
  _TopTabState createState() => _TopTabState();
}

//Top tab returns a tab bar which would consist of 4 tabs
class _TopTabState extends State<TopTab> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: tabsName.length,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.blue,
          isScrollable: true,
          tabs: [
            for (var item in tabsName) Tab(child : Text(item))
          ],
        ),
        body: TabBarView(
          children: [
            UploadDataTab(),
            firstDifference(),
            UploadSettingsTabState(),
            stationarityTest(),
            DiscretizeValues(),
          ],
        ),
      ),
    );
  }
}

class DiscretizeValues extends StatefulWidget {
  @override
  _DiscretizeValuesState createState() => _DiscretizeValuesState();
}

class _DiscretizeValuesState extends State<DiscretizeValues> {
  void toggle() async {

      Map<String,String> results = await togglediscretize();
      //if request pass
      if (results['results'] == "pass"){
        final snackBar = SnackBar(content: Text('Successfully Toggled Discretize!'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
      //if result fail
      else{
        final snackBar = SnackBar(content: Text(results['details']));
        Scaffold.of(context).showSnackBar(snackBar);
      }
  }
  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
        Center(
          child: Container(
            child: generateOutlinedButton("Discretize", setState, toggle),
          ),
        )
    );
  }
}

class firstDifference extends StatefulWidget {
  @override
  _firstDifferenceState createState() => _firstDifferenceState();
}

class _firstDifferenceState extends State<firstDifference> {

  _toggledifference() async {
    Map<String,String> results = await toggledifference();
    //if request pass
    if (results['results'] == "pass"){
      final snackBar = SnackBar(content: Text('Successfully Toggled First Difference!'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    //if result fail
    else{
      final snackBar = SnackBar(content: Text(results['details']));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
        Center(
          child: Container(
            child: generateOutlinedButton("Toggle first order difference", setState, _toggledifference),
          ),
        )
    );
  }
}


class stationarityTest extends StatefulWidget {
  @override
  _stationarityTestState createState() => _stationarityTestState();
}

class _stationarityTestState extends State<stationarityTest> {

  void _toggleStationaryTest() async {
    Map<String,String> results = await runStationarity(adfSig, johSig);
    setState(() {
      stationaryState  = results["details"];
    });
    final snackBar = SnackBar(content: Text("Results of Stationary Test Recieved"));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void setADF(String value){
    adfSig = value;
  }

  void setJohansen(String value){
    johSig = value;
  }

  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex : 1,
            child :  Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: generateDropDown('ADF Significant', adf_significant_items, adfSig, setADF, setState)
                    ),
                    Flexible(
                        child: generateDropDown('Joh Significant', joh_significant_items, johSig, setJohansen, setState)
                    ),
                    Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            _toggleStationaryTest();
                          },
                          child: Text("Submit"),
                        )
                    )
                  ],
                ),
              ),
          ),

          Flexible(
              flex : 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6,0,0,0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: SingleChildScrollView(
                        child: Text('$stationaryState')
                    ),
                  ),
                ),
              )
          ),
        ],
      )
    );
  }
}


class UploadSettingsTabState extends StatefulWidget {
  @override
  _uploadSettingsTabState createState() => _uploadSettingsTabState();
}

// ignore: camel_case_types
class _uploadSettingsTabState extends State<UploadSettingsTabState> {
  void _toggleUpload() async {
    pathdirectorySettingsUpload = "Upload";
  }
  void _toggleDownload() async {
    pathdirectorySettingsDownload = "Download";
  }
  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
        Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
              children: [
                generateOutlinedButton(pathdirectorySettingsUpload, setState, _toggleUpload),
                generateOutlinedButton(pathdirectorySettingsDownload, setState, _toggleDownload),
              ],
            ),
          ),
        )
    );
  }
}

//First tab of the top tab bar.
//consist of just a button to upload a csv to the server
//Will proceed to update button to the file name
//Will proceed to show the reults of the upload
class UploadDataTab extends StatefulWidget {
  @override
  _uploadDataTabState createState() => _uploadDataTabState();
}

// ignore: camel_case_types
class _uploadDataTabState extends State<UploadDataTab> {

  //function to toggle the upload of csv
  //uploadSelectedFile will return a map of details
  //name to get the path
  //results to get pass or failed uploading
  //setstate to init the rendering of the updated button when pass

  void _toggleUpload() async {

    Map<String,String> results = await uploadSelectedFile();
    //if request pass
    if (results['results'] == "pass"){
      setState(() {
        pathdirectoryCSV = "Uploaded File Successfully";
      });
      final snackBar = SnackBar(content: Text(pathdirectoryCSV));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    //if result fail
    else{
      final snackBar = SnackBar(content: Text(results['details']));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
  //tab just consist of a outlined button.
  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex : 1,
              child : Align(
                alignment: Alignment.centerRight,
                child: generateOutlinedButton("Path", setState, _toggleUpload),
              ),
            ),
            Flexible(
                flex : 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6,0,0,0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: SingleChildScrollView(
                          child: Text('$pathdirectoryCSV')
                      ),
                    ),
                  ),
                )
            ),
          ],
        )

        // Center(
        //   child: Container(
        //     child: generateOutlinedButton(pathdirectoryCSV, setState, _toggleUpload),
        //   ),
        // )
    );
  }
}


