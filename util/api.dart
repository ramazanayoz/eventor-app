import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/models/settings.dart';
import 'package:eventor/denem9-firebaseTum/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class XApi{
  //var
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;
  

  XApi(this.path){
    ref = _db.collection(path);
  }

  Future<String> createUser(email,password) async {
  AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid ;
  } 

  Future<String> signIn(email,password) async {
    AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }

  Future<void> addToDatabaseUser(XUser xuser) async {
        Firestore.instance
            .document("users/${xuser.userId}")
            .setData(xuser.classObjConvertToJson());//alınan bilgiler json yani map formata çevrilir database eklemek için
  }

  Future<void> addToDatabaseSetting(XSettings xsettings) async {
    Firestore.instance
        .document("settings/${xsettings.settingsId}")
        .setData(xsettings.convertToJsonMap()); //firebase eklemek için fjson yani map formata çevriliyor    
  }

  Future<DocumentSnapshot> checkingUser(userId) async{
        return Firestore.instance.document("users/$userId").get();
  }

  Future<void> sendPassword(email) async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}

 