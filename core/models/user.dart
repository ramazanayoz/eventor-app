import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

XUser stringjsonConvertToClassobj(String str) {
  final jsonData = json.decode(str);
  print("userFromJson json.decode(str) ${json.decode(str)}");
  return XUser.mapJsonConvertToClassObj(jsonData);
}

String classObjConvertToJsonString(XUser data) {
  final dyn = data.classObjConvertToJson();
  return json.encode(dyn);
}

class XUser {
  String userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String imageUrl;
  String imageLoc;

  XUser({   //constructur
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.imageUrl,
    this.imageLoc,
  });

  factory XUser.mapJsonConvertToClassObj(Map<String, dynamic> json) => new XUser(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageUrl"],
        imageLoc: json["imageLoc"],
      );  //  XUser nesnesi oluşturuluyor firebaseden alınan parametrelerle

  Map<String, dynamic> classObjConvertToJson() => { //user bilgileri json yani map formate çevriliyor
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
        "imageLoc": imageLoc,
      };

  factory XUser.docConvertToClassObj(DocumentSnapshot doc) {
    //print("fromDocument docSnap.data: ${doc.data}");
    print("fromDocument docSnap.data: "+ doc.data["userId"]);
    return XUser.mapJsonConvertToClassObj(doc.data);
  }
}
