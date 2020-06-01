import 'dart:io';

import 'package:flutter/material.dart';

class XEditProfileProvider with ChangeNotifier{
  bool isActiveTextInput = false;
  File image;
  String imageUrl;
  bool status=true;

  void switchTextInputActiviness(){
    isActiveTextInput= !isActiveTextInput;
    notifyListeners();
  }

  void changeImagePic(File image){
    this.image = image;
    notifyListeners();
  }

  void changeImageUrl(String imageUrl){
    this.imageUrl =imageUrl;
    notifyListeners();
  }

  void makeNotify(){
    notifyListeners();
 
  }


}