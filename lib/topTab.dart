import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgetFactory.dart';
import 'connections.dart';
List<String> tabsName = ["Upload Data", "Upload Settings", "Stationarity Test", "Discretize Values"];
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

class TopTab extends StatefulWidget {
  @override
  _TopTabState createState() => _TopTabState();
}

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
  void toggle(){

  }
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
                child: generateOutlinedButton(discretizedState, setState, toggle),
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
                          child: Text('$discretizedState')
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


class stationarityTest extends StatefulWidget {
  @override
  _stationarityTestState createState() => _stationarityTestState();
}

class _stationarityTestState extends State<stationarityTest> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex : 1,
            child :  Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: generateDropDown('ADF Significant', adf_significant_items, adfSig, setState)
                    ),
                    Flexible(
                        child: generateDropDown('Joh Significant', joh_significant_items, johSig, setState)
                    ),
                    Flexible(
                        child: ElevatedButton(
                          onPressed: () {
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

class UploadDataTab extends StatefulWidget {
  @override
  _uploadDataTabState createState() => _uploadDataTabState();
}

// ignore: camel_case_types
class _uploadDataTabState extends State<UploadDataTab> {
  void _toggleUpload() async {
    upload();
    pathdirectoryCSV = "Test CSV";
  }
  @override
  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
        Center(
          child: Container(
            child: generateOutlinedButton(pathdirectoryCSV, setState, _toggleUpload),
          ),
        )
    );
  }
}