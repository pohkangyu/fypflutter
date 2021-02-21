import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'importFile.dart';
List<String> tabsName = ["Upload Data", "Upload Settings", "Stationarity Test", "Discretize Values"];
String pathdirectoryCSV = "Select Path To Upload";
String pathdirectorySettings = "Select Path To Upload";
String stationaryState = "Pass!";
String discretizedState = "Pass!";
Map<String, double> significant = { "1%": 0.01, "5%": 0.05,  "10%": 0.1 };
String johSig = significant.keys.first;
String adfSig = significant.keys.first;

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
  @override
  Widget build(BuildContext context) {
    return wrapForTabs(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex : 1,
              child : Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  child: Text(
                    "Run",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    setState(() {
                      discretizedState = "Pass" * 200;
                    });
                  },
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
  List<DropdownMenuItem<String>> adf_significant_items = [];
  List<DropdownMenuItem<String>> joh_significant_items = [];

  _stationarityTestState()
  {
    significant.forEach((key, value) {
      adf_significant_items.add(
          new DropdownMenuItem<String>(
            child: Text(key),
            value: key,
          )
      );
    });
    significant.forEach((key, value) {
      joh_significant_items.add(
          new DropdownMenuItem<String>(
            child: Text(key),
            value: key,
          )
      );
    });
  }

  Widget getFormWidget(){
    return
        Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: DropdownButtonFormField(
                  items :adf_significant_items,
                  value : adfSig,
                  onChanged: (value) {
                    setState(() {
                      adfSig = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      labelStyle: TextStyle(),
                      labelText: 'ADF Significant'),
                ),
              ),
              Flexible(
                child: DropdownButtonFormField(
                  items :joh_significant_items,
                  value : johSig,
                  onChanged: (value) {
                    setState(() {
                      johSig = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      labelStyle: TextStyle(),
                      labelText: 'Joh Significant'),
                ),
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

        );
  }

  @override
  Widget build(BuildContext context) {
    return wrapForTabs(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex : 1,
            child : getFormWidget(),
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


class UploadDataTab extends StatefulWidget {
  @override
  _uploadDataTabState createState() => _uploadDataTabState();
}

class _uploadDataTabState extends State<UploadDataTab> {
  void _toggleUpload() {
    pathdirectoryCSV = "C:\\Data.csv";
  }
  @override
  Widget build(BuildContext context) {
    return wrapForTabs(
        Center(
          child: Container(
            child:
            OutlinedButton(
              child: Text(
                '$pathdirectoryCSV',
                style: new TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                setState(() {
                  _toggleUpload();
                });
              },
            ),
          ),
        )
    );
  }
}

class UploadSettingsTabState extends StatefulWidget {
  @override
  _uploadSettingsTabState createState() => _uploadSettingsTabState();
}

class _uploadSettingsTabState extends State<UploadSettingsTabState> {
  void _toggleUpload() {
    pathdirectorySettings = "C:\\Settings.csv";
    var test = WebFile();
    print(test.getPath());
  }
  @override
  Widget build(BuildContext context) {
    return wrapForTabs(
        Center(
          child: Container(
            child:
            OutlinedButton(
              child: Text(
                '$pathdirectorySettings',
                style: new TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                setState(() {
                  _toggleUpload();
                });
              },
            ),
          ),
        )
    );
  }
}

Container wrapForTabs(Widget child){
  return Container(
    margin: EdgeInsets.all(10.0),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.blue,
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: child,
  );
}