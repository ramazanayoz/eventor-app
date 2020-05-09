import 'dart:io';

import 'package:flutter/material.dart';

class XEventFormProv extends ChangeNotifier {
  
  String title ;
  String category;
  String startDate;
  String endDate;
  String price;
  String instructur;
  String maxParticipant; 
  String briefDescription; 
  String description;
  File imageFile;

  String address; 
  String country;
  String state;
  String city;
  String locality;
  String sublocality;
  String thoroughfare;
  String subThoroughfare;
  String postalCode;

  double latitude;
  double longitude;
  List myCategoryList;


      //country
      //administrativeArea = state   türkiyede şehire karşılık gelir
      //locality = türkçesi semt
      //subLocality =  //türkiye de mahalle
      //thoroughfare  //türkiyede cadde
      //subThoroughfare  //türkiyede kapı no
      //name //türkiye de kapı no

  XEventFormProv(){
    this.title = title ; 
    this.category = category ; 
    this.startDate = startDate ?? ""; 
    this.endDate = endDate ?? ""; 
    this.price = price ?? ""; 
    this.instructur = instructur ?? ""; 
    this.maxParticipant = maxParticipant ?? ""; 
    this.briefDescription = briefDescription ?? ""; 
    this.description = description ?? ""; 
    this.imageFile = imageFile;
    this.address = address ?? ""; 
    this.country = country ?? ""; 
    this.state = state ?? ""; 
    this.city = city ?? ""; 
    this.locality = locality ?? ""; 
    this.sublocality = sublocality ?? ""; 
    this.thoroughfare = thoroughfare ?? ""; 
    this.subThoroughfare = subThoroughfare ?? ""; 
    this.postalCode = postalCode ?? ""; 
    this.latitude = latitude ?? 0 ; 
    this.longitude = longitude ?? 0 ; 
    this.myCategoryList = myCategoryList ?? [];
  } 

  void reset(){
    this.title = "" ; 
    this.category = "" ; 
    this.startDate =  ""; 
    this.endDate =  ""; 
    this.price =  ""; 
    this.instructur =  ""; 
    this.maxParticipant = ""; 
    this.briefDescription = ""; 
    this.description =  ""; 
    this.imageFile = null;
    this.address = ""; 
    this.country =  ""; 
    this.state =  ""; 
    this.city =  ""; 
    this.locality = ""; 
    this.sublocality =  ""; 
    this.thoroughfare =  ""; 
    this.subThoroughfare = ""; 
    this.postalCode =  ""; 
    this.latitude =  0 ; 
    this.longitude = 0 ; 
    this.myCategoryList = [];
  }



}