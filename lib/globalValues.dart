

import 'dart:core';

int globalNumber = 66;
String globalString = 'This is a global string';
double globalDouble = 0.0;
var globalVar = 'This is a global var';
bool globalBool = false;

class AppData {
  int number = 0;
  String string = 'This is a string';
  bool boolTest = false;

  void setNumber(int number) {
    this.number = number;
  }

  void setString(String string) {
    this.string = string;
  }

  void setBool(bool bool) {
    this.boolTest = bool;
  }

  int getNumber() {
    return this.number;
  }

  String getString() {
    return this.string;
  }

  bool getBool() {
    return this.boolTest;
  }
}