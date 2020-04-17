import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class XEventApi{
 
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;
  String _documentId;
  static String _eventId;

  XEventApi(this.path){
    ref = _db.collection(path);
  }


  Future<void> addEventToDatabase(XEvent xevent) async {
      Map<String, dynamic>  mapobject = xevent.classObjConvertToJson();
      DocumentReference documentId= await ref.add(mapobject);
      _eventId = documentId.documentID;
      xevent.eventId =  _eventId;
    await  _db.collection("events").document(xevent.eventId).setData(xevent.classObjConvertToJson());
  }



  Future<void> addLocationToDatabase(XLocation xlocation) async {
    xlocation.eventId = _eventId;
    await _db.collection("locations").document(_documentId).setData(xlocation.classObjConvertToJson());
  }



  Future<String> uploadImage(File image,String name) async{
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

  Future<String> getImageUrl(String textImageLocation)async{
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