
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

XEvent stringjsonConvertToClassobj(String str) {
  final jsonData = json.decode(str);
  print("userFromJson json.decode(str) ${json.decode(str)}");
  return XEvent.mapJsonConvertToClassObj(jsonData);
} 

String classObjConvertToJsonString(XEvent data) {
  final dyn = data.classObjConvertToJson();
  return json.encode(dyn);
}



class XEvent{
  String userId;
  String imageLocation;
  String imageUrl;
  String title;
  String category;
  String startDate;
  String endDate;
  String price;
  String instructur;
  String maxParticipant;
  String briefDescription;
  String description;
  String eventId;

  //constructur
  XEvent({
    this.userId,
    this.imageLocation,
    this.imageUrl,
    this.title,
    this.category,
    this.startDate,
    this.endDate,
    this.price,
    this.instructur,
    this.maxParticipant,
    this.briefDescription,
    this.description,
    this.eventId,
  });

  

  //METHODS
  factory XEvent.mapJsonConvertToClassObj(Map<String, dynamic> json) => new XEvent(
        userId: json["userId"],
        imageLocation: json["imageLocation"],
        imageUrl: json["imageUrl"],
        title: json["title"],
        category: json["category"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        price: json["price"],
        instructur: json["instructur"],
        maxParticipant: json["maxParticipant"],
        briefDescription: json["briefDescription"],
        description: json["description"],
      ); //  XEvent nesnesi oluşturuluyor firebaseden alınan parametrelerle

  Map<String, dynamic> classObjConvertToJson() => {//event bilgileri json yani map formate çevriliyor
        "userId": userId,
        "imageLocation" : imageLocation,
        "imageUrl": imageUrl, 
        "title": title,
        "category": category,
        "startDate": startDate,
        "endDate": endDate,
        "price": price,
        "instructur": instructur,
        "maxParticipant": maxParticipant,
        "briefDescription": briefDescription,
        "description": description,  
        "eventId" : eventId,  
  };

  factory XEvent.docConvertToClassObj(DocumentSnapshot doc){
    print("fromDocument docSnap.data: "+ doc.data["userId"]);
    return XEvent.mapJsonConvertToClassObj(doc.data);
  }

}

