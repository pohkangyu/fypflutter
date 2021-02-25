import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

DropdownMenuItem<String> generateDropDownMenuItem(value){
  return DropdownMenuItem<String>(
    child: Text(value),
    value: value,
  );
}


DropdownButtonFormField generateDropDown(String label, List<DropdownMenuItem<String>> items, String selectedValue, Function setState){
  return DropdownButtonFormField(
    items : items,
    value : selectedValue,
    onChanged: (selectedValue) {
      setState(() {
        selectedValue = selectedValue;
      });
    },
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        labelStyle: TextStyle(),
        labelText: label),
  );
}


OutlinedButton generateOutlinedButton(String buttonText, Function setState, Function toggleEvent){
  return OutlinedButton(
    child: Text(
      '$buttonText',
      style: new TextStyle(fontSize: 18.0),
    ),
    onPressed: () {
      setState(() {
        toggleEvent();
      });
    },
  );
}


//this method will wrap the child in a tab
//giving it a blue border and grey background
Container wrapBlueBorderGreyBackGroundTab(Widget child){
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