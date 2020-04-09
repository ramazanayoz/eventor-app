import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';

class XEventApi{
 
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;
   String _documentId;

  XEventApi(this.path){
    ref = _db.collection(path);
  }

  Future<DocumentReference> addEventToDatabase(Map mapobject) async {
       DocumentReference documentId= await ref.add(mapobject);
       _documentId = documentId.documentID;
   return documentId;
    
  }

  Future<void> setEventToDatabase(XEvent xevent) async {
     await  _db.collection("events").document(xevent.eventId).setData(xevent.classObjConvertToJson());
  }

  Future<void> setLocationToDatabase(XLocation xlocation) async {
    await _db.collection("locations").document(_documentId).setData(xlocation.classObjConvertToJson());
  }

}