import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

class XLocationApi{
 
  Future<XLocation> getLocationFromId(String id) async {
    XLocation xlocation;

    Query query = Firestore.instance.collection("locations").where("eventId", isEqualTo: id);
    await query.getDocuments().then((QuerySnapshot querySnapshot) async {
      if(querySnapshot.documents != null){
        //print("doc snapshot ${querySnapshot.documents}");
        DocumentSnapshot docSnapshot =  querySnapshot.documents[0];
        Map<String, dynamic> mapData = docSnapshot.data;
        XLocation location =   XLocation.mapConvertClass(mapData);
        xlocation =  location; 
      }else{
        //xlocation = null;
      }
    }); 
    //print("locationumm: ${xlocation}");
    return xlocation;
  }

Future<List<XLocation>> fetchAllLocation(FirebaseUser currentUser) async{

  List<XLocation> locationList = [];


  QuerySnapshot querySnap= await Firestore.instance.collection("locations").getDocuments();
    print("fetchAllLocation");
    for(var i = 0; i < querySnap.documents.length; i++){
      locationList.add(XLocation.mapConvertClass(querySnap.documents[i].data));
      //print("zaza: ${querySnap.documents[i].data}");
    }
  return locationList;

}

}