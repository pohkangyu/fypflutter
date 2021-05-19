import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'widgetFactory.dart';
import 'connections.dart';
import 'package:intl/intl.dart';

String url = "http://127.0.0.1:5000/";

final max_lag_sourceController = new TextEditingController(text: "5");
final min_lag_sourceController = new TextEditingController(text: "1");
final max_lag_targetController = new TextEditingController();
final tau_sourcesController = new TextEditingController();
final tau_targetController = new TextEditingController();
final n_perm_max_statController = new TextEditingController();
final n_perm_min_statController = new TextEditingController();
final n_perm_omnibusController = new TextEditingController();
final n_perm_max_seqController = new TextEditingController();
final alpha_max_statsController = new TextEditingController();
final alpha_min_statsController = new TextEditingController();
final alpha_omnibusController = new TextEditingController();
Image imagechild = Image.asset('assets/images/img.png');
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

Future<String> getSettings() async {
  List<List<String>> inputTE = [
    ['cmi_estimator', cmi_item],
    ["max_lag_sources", max_lag_sourceController.text],
    ["min_lag_sources", min_lag_sourceController.text],
    ["max_lag_target", max_lag_targetController.text],
    ["tau_sources", tau_sourcesController.text],
    ["tau_target", tau_targetController.text],
    ["n_perm_max_stat", n_perm_max_statController.text],
    ["n_perm_min_stat", n_perm_min_statController.text],
    ["n_perm_omnibus", n_perm_omnibusController.text],
    ["n_perm_max_seq", n_perm_max_seqController.text],
    ["alpha_max_stats", alpha_max_statsController.text],
    ["alpha_min_stats", alpha_min_statsController.text],
    ["alpha_omnibus", alpha_omnibusController.text],
  ];
  String csv = const ListToCsvConverter().convert(inputTE);
  return csv;
}


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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  toggleLocalTE(Map<String, String> inputTE) async {
    Map<String,String> results = await toggleTE(inputTE);

    //if request pass
    if (results['results'] == "pass"){
      setState(() {
        String imageUrl = "http://127.0.0.1:5000/get_image?v=${DateTime.now().millisecondsSinceEpoch}";
        imagechild = Image.network(imageUrl);
      });
      final snackBar = SnackBar(content: Text('Successfully ran TE'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    //if result fail
    else{
      final snackBar = SnackBar(content: Text(results['details']));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
  Widget build(BuildContext context) {

    return wrapBlueBorderGreyBackGroundTab(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex : 2,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        final Map<String, String> inputTE = {
                          'cmi_estimator' : cmi_item,
                          "max_lag_sources" : max_lag_sourceController.text,
                          "min_lag_sources" : min_lag_sourceController.text,
                          "max_lag_target" : max_lag_targetController.text,
                          "tau_sources" : tau_sourcesController.text,
                          "tau_target" : tau_targetController.text,
                          "n_perm_max_stat" : n_perm_max_statController.text,
                          "n_perm_min_stat" : n_perm_min_statController.text,
                          "n_perm_omnibus" : n_perm_omnibusController.text,
                          "n_perm_max_seq" : n_perm_max_seqController.text,
                          "alpha_max_stats" : alpha_max_statsController.text,
                          "alpha_min_stats" : alpha_min_statsController.text,
                          "alpha_omnibus" : alpha_omnibusController.text,
                        };
                        toggleLocalTE(inputTE);
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }

                    },
                    child: Text("Run"),
                  ),

                  Expanded(
                    child: Container(
                      child:

                      Container(
                        child: ListView(
                          children: <Widget>[
                            generateChoice(setState, cmi_items, cmi_item, "Estimator to be used for CMI calculation", 'cmi_estimator'),
                            generateIntegerInput("max_lag_sources", "Maximum temporal search depth for candidates in the sources' past in samples", max_lag_sourceController),
                            generateIntegerInput("min_lag_sources", "Minimum temporal search depth for candidates in the sources' past in samples",  min_lag_sourceController),
                            generateIntegerInput("max_lag_target", "Maximum temporal search depth for candidates in the target's past in sample, default=same as max_lag_sources",  max_lag_targetController),
                            generateIntegerInput("tau_sources", "Spacing between candidates in the sources' past in samples",tau_sourcesController),
                            generateIntegerInput("tau_target", "Spacing between candidates in the target's past in sample, default = 1", tau_targetController),
                            generateIntegerInput("n_perm_max_stat", "Number of permutations for Max Stat", n_perm_max_statController),
                            generateIntegerInput("n_perm_min_stat", "Number of permutations for Min Stat", n_perm_min_statController),
                            generateIntegerInput("n_perm_omnibus", "Number of permutations for Omnibus", n_perm_omnibusController),
                            generateIntegerInput("n_perm_max_seq", "Number of permutations for Max Sequence", n_perm_max_seqController),
                            generateIntegerInput("alpha_max_stats", "Critical alpha level for statistical significance", alpha_max_statsController),
                            generateIntegerInput("alpha_min_stats", "Critical alpha level for statistical significance", alpha_min_statsController),
                            generateIntegerInput("alpha_omnibus", "Critical alpha level for statistical significance", alpha_omnibusController),
                          ],
                        ),
                      )
                  ),
                  )
                ],
              )
            ),
          ),
          Expanded(
            flex : 4,
            child: Container(child: imagechild),
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
                  cmi_item = value;
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

  Widget generateIntegerInput(String label, String message, TextEditingController control) {
    return Tooltip(
      message : message,
      child: Card(
        child: ListTile(
          title : TextFormField(
            controller: control,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                labelStyle: TextStyle(),
                labelText: label),
            keyboardType: TextInputType.number,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Please enter some text';
            //   }
            //   return null;
            // },
          ),
        ),
      ),
    );
  }
}


