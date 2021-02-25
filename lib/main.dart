import 'package:flutter/material.dart';
import 'topTab.dart' as topTab;
import 'bottomTab.dart'as bottomTab;

void main() {
  runApp(MyApp());
}

//Simply returns Widget and add a title
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multivariate Time Series',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage("Multivariate Time Series"),
    );
  }
}

//Simple return a column with 2x tab. Look into bottomTab.dart and topTab.dart for more details.
class HomePage extends StatelessWidget {
  var title;
  HomePage(String inputTitle){
    title = inputTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex : 1,
                child: topTab.TopTab()
            ),
            Expanded(
                flex : 3,
                child: bottomTab.BottomTab()
            ),
          ],
        ),
      ),
    );
  }
}


