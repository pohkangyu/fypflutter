import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgetFactory.dart';


List<DropdownMenuItem<String>> cmi_items = [
  new DropdownMenuItem<String>(
    child: Text("JidtKraskovCMI"),
    value: "JidtKraskovCMI",
  ),
  new DropdownMenuItem<String>(
    child: Text("JidtDiscreteCMI"),
    value: "JidtDiscreteCMI",
  ),
  new DropdownMenuItem<String>(
    child: Text("JidtGaussianCMI"),
    value: "JidtGaussianCMI",
  )
];
String cmi_item = "JidtGaussianCMI";


class BottomTab extends StatefulWidget {
  @override
  _BottomTab createState() => _BottomTab();
}

class _BottomTab extends State<BottomTab> {
  List<String> tabsName = ["MultiVariate Time Series"];



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
            MuteTE(),
          ],
        ),
      ),
    );
  }
}

class MuteTE extends StatefulWidget {
  @override
  _MuteTEState createState() => _MuteTEState();
}

class _MuteTEState extends State<MuteTE> {
  @override
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return wrapBlueBorderGreyBackGroundTab(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex : 1,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }

                    },
                    child: Text("Run"),
                  ),

                  Expanded(
                    child: Container(
                      child:
                      ListView(
                        children: <Widget>[
                          generateChoice(setState, cmi_items, cmi_item, "Estimator to be used for CMI calculation", 'cmi_estimator'),
                          generateIntegerInput("max_lag_source", "Maximum temporal search depth for candidates in the sources' past in samples", "5"),
                          generateIntegerInput("min_lag_source", "Minimum temporal search depth for candidates in the sources' past in samples", "1"),
                          generateIntegerInput("max_lag_target", "Maximum temporal search depth for candidates in the target's past in sample, default=same as max_lag_sources", "5"),
                          generateIntegerInput("tau_sources", "Spacing between candidates in the sources' past in samples", "1"),
                          generateIntegerInput("tau_target", "Spacing between candidates in the target's past in sample, default = 1", "1"),
                        ],
                      )
                  ),
                  )
                ],
              )
            ),
          ),
          Expanded(
            flex : 4,
            child: Container(child: Image.asset('assets/images/img.png')),
          ),
        ],
      )
    );
  }

  Widget generateChoice(void Function(VoidCallback fn) setState, List<DropdownMenuItem<String>> item_list, String item, String message, String label) {
    return Tooltip(
      message : message,
      child: Card(
        child: ListTile(
          title : Container(
            child: DropdownButtonFormField(
              items : item_list,
              value : item,
              onChanged: (value) {
                setState(() {
                  item = value;
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  labelText: label),
            ),
          ),
        ),
      ),
    );
  }

  Widget generateIntegerInput(String label, String message, String inital) {
    return Tooltip(
      message : message,
      child: Card(
        child: ListTile(
          title : TextFormField(
            initialValue: inital,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                labelStyle: TextStyle(),
                labelText: label),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}


