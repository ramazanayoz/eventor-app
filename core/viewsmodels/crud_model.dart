import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:eventor/denem9-firebaseTum/core/services/event_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class XCrudModel extends ChangeNotifier{
  //VAR
  static XEventApi _eventApi = XEventApi("events");
  static String _eventId;

  //FUNCT
  static Future addEventDatabase(XEvent xevent) async{
    _eventId = await _eventApi.addEventToDatabase(xevent.classObjConvertToJson()).then((onValue)  {
      return  onValue.documentID;
    });  
    xevent.eventId =  _eventId;
   // print("kokokokok: ${xevent.eventId}");
    await _eventApi.setEventToDatabase(xevent);

  }

  static Future addLocationDatabase(XLocation xlocation) async{
    xlocation.eventId = _eventId;
    await _eventApi.setLocationToDatabase(xlocation);
  }



  static Future<String> uploadImage(File image,String name) async{
    try {
      //make random image name.
      String imageLocation = 'images/events/events-$name-${new DateFormat("yyyy-MM-dd-HH:mm").format(new DateTime.now())}.jpg';

      //Upload image to firebase
      final StorageReference strogaReference = FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = strogaReference.putFile(image);
      await uploadTask.onComplete;
     // _addPathToDatabase(imageLocation);
      return imageLocation;

    }catch(e){
      print(e.message);
    }
  }
  

  static Future<String> getImageUrl(String textImageLocation)async{
     try{
      //get image Url from firebase
      final ref = FirebaseStorage().ref().child(textImageLocation);
      return  await ref.getDownloadURL();

      //Add location and url to database
      //await Firestore.instance.collection('strage').document().setData({'url': imageString, 'localStroge': textImageLocation});
    }catch(e){
      print(e.message);
    }
  }

}