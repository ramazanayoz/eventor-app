import 'package:flutter/material.dart';

 class XAppState extends ChangeNotifier {

  String selectedCategoryName;

  //constructur initiliza
  XAppState(){
     selectedCategoryName = selectedCategoryName ?? 'All' ;
  }  

  //FUNCT
  void updateCategoryId(String selectedCategoryName) {
    this.selectedCategoryName = selectedCategoryName;
    notifyListeners(); 
  }

 }