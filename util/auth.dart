import 'dart:async';
//import 'dart:convert';
import 'package:eventor/denem9-firebaseTum/models/state.dart';
import 'package:eventor/denem9-firebaseTum/util/state_widget.dart';
import 'package:flutter/foundation.dart';

import '../util/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/settings.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class XAuth extends ChangeNotifier{

  //VAR
  XApi xapi = XApi("users");

  //SİGN UP KISIM
   Future<String> signUp(String email, String password) async {
     print("signUp working");
    return xapi.createUser(email, password);
  }

  Future addUserSettingsDB(XUser xuser) async {  //kullanıcı firebase db kaydediliyor
    checkUserExist(xuser.userId).then((value) async {
      if (!value) {
        print("user ${xuser.firstName} ${xuser.email} added");
        print("not auth: user.toJson(): ${xuser.classObjConvertToJson()}");
        
        await xapi.addToDatabaseUser(xuser); //alınan bilgiler json yani map formata çevrilir database eklemek için
        
        _addSettings(new XSettings(
          settingsId: xuser.userId,
        ));
      } else {
        print("user ${xuser.firstName} ${xuser.email} exists");
      }
    });
  } 

   Future<bool> checkUserExist(String userId) async {
    print("not: auth: checkUserExist fonk");
    bool exists = false;
    try {
      await xapi.checkingUser(userId).then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

   void _addSettings(XSettings xsettings) async {
    print("not: Xauth _addSettings fonc working");
    
    xapi.addToDatabaseSetting(xsettings);

    print("not: auth:  settings.toJson(): ${xsettings.convertToJsonMap()}");
  }


  //SİGN IN KISIM
  Future<String> logInUser(String email, String password,context) async {
    
    String userId = await xapi.signIn(email, password); 
    XUser user = await getUserFirestore(userId); //XUser nesnesi oluşturuluyor firebaseden alınan verilerle
    await storeUserInfoLocal(user); //user bilgileri string olarak telefolna depolanır
    XSettings settings = await getSettingsFirestore(userId);
    await storeSettingsLocal(settings);
    XStateWidget.of(context).initUser();


  }





  static Future<XUser> getUserFirestore(String userId) async {
    //---:auth: getUserFirestore fonk çalışıyor ve  user uid ile firebase documansnapshot nesnesine ulaşılır"
    print(":auth: getUserFirestore(String userId) fonk");
    if (userId != null) {
      return Firestore.instance
          .collection('users')
          .document(userId)
          .get()
          .then((documentSnapshot) => XUser.docConvertToClassObj(documentSnapshot));  
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  static Future<XSettings> getSettingsFirestore(String settingsId) async {
    print(":auth:  getSettingsFirestore(String settingsId) fonk");
    if (settingsId != null) {
      return Firestore.instance
          .collection('settings')
          .document(settingsId)
          .get()
          .then((documentSnapshot) => XSettings.docConvertToSettingClassObj(documentSnapshot));
    } else {
      print('no firestore settings available');
      return null;
    }
  }

    static Future<FirebaseUser> getCurrentFirebaseUser() async {
    print("not:auth: getCurrentFirebaseUser fonk");    
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  //SAVİNG lOCAL STRAGE
  static Future<String> storeUserInfoLocal(XUser user) async {
    //print(":auth: storeUserLocal(XUser user) fonk working");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = classObjConvertToJsonString(user);
    //print("---:storeUser var: $storeUser");
    await prefs.setString('user', storeUser);
    return user.userId;
  }

  static Future<String> storeSettingsLocal(XSettings settings) async { //kullanıcı adı gibi bilgiler telefona yerel olarak kaydetme
    print("not:auth: storeSettingsLocal(XSettings settings) fonk");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeSettings = settingsObjectToJsonString(settings);
    print(" storeSettings var ${storeSettings}");
    await prefs.setString('settings', storeSettings);
    return settings.settingsId;
  }


  //GETTİNG lOCAL STRAGE
  static Future<XUser> getUserLocal() async { //tekrar kullanıcı parala kgirmesin diye depolanan yerden kullanıcı ayaralrı alma
    print("not:auth: getUserLocal fonk");    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      XUser user = stringjsonConvertToClassobj(prefs.getString('user'));
      print("not: auth :user: prefs.getString('user') ${prefs.getString('user')}");
      print('USER: $user');
      return user;
    } else {
      return null;
    }
  }

  static Future<XSettings> getSettingsLocal() async {
    print("not:auth: getSettingsLocal fonk");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('settings') != null) {
      XSettings settings = settingsFromJson(prefs.getString('settings'));
      print("auth getSettingsLocal() prefs.getString('settings') : } ${prefs.getString('settings')}");
      return settings;
    } else {
      return null;
    }
  }



  Future<void> logOutUser(context) async {
   // print("not:XStateWidget da logOutUser running");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();

    FirebaseUser firebaseUserAuth = await getCurrentFirebaseUser(); // signout yaptık ve şuanki null olan kullanıcıyı aldık
   // print("not:state:logOutUser() fonc firebaseUserAuth  ${firebaseUserAuth} ");
    XStateWidget.of(context).ChangeStateForlogOutUser(firebaseUserAuth);
  }

  

  Future<void> forgotPasswordEmail(String email) async {
    xapi.sendPassword(email);
  }

  static String getExceptionText(Exception e) {
    print("not:auth: getExceptionText(Exception e) fonk");
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

  /*static Stream<User> getUserFirestore(String userId) {
    print("...getUserFirestore...");
    if (userId != null) {
      //try firestore
      return Firestore.instance
          .collection("users")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return User.fromDocument(doc);
        }).first;
      });
    } else {
      print('firestore user not found');
      return null;
    }
  }*/

  /*static Stream<Settings> getSettingsFirestore(String settingsId) {
    print("...getSettingsFirestore...");
    if (settingsId != null) {
      //try firestore
      return Firestore.instance
          .collection("settings")
          .where("settingsId", isEqualTo: settingsId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return Settings.fromDocument(doc);
        }).first;
      });
    } else {
      print('no firestore settings available');
      return null;
    }
  }*/
}
