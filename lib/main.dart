import 'package:flutter/material.dart';
import 'topTab.dart' as topTab;
import 'bottomTab.dart'as bottomTab;

//main function to run the app.
void main() {
  runApp(MyApp());
}

//App returns and render a stateless widget.
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

//Only stateless widget returned. It consist of a upper tab and a lower tab.
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


