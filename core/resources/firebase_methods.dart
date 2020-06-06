import 'dart:async';
import 'dart:io';
//import 'dart:convert';
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/event_api.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/user_api.dart';
import 'package:flutter/cupertino.dart';

import '../../core/services/state_widget.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/settings.dart'; 
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location_api.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class XFirebaseMethod extends ChangeNotifier{

  //VAR
  XApi xapi = XApi("users");
  static XEventApi _eventApi = XEventApi("events");
  XLocationApi _locationApi = XLocationApi();
  //SİGN UP KISIM
  Future<String> signUp(String displayName,String email, String password) => xapi.createUser(displayName,email,password);

  Future<void> addUserSettingsDB(XUser xuser) => xapi.addToDatabaseUser(xuser); 

  Future<void> updateProfileInfo(XUser xuser,String currentPassword, String newPassword, BuildContext context) async => await xapi.updateProfile(xuser, currentPassword, newPassword, context);

  Future<bool> checkUserExist(String userId) => xapi.checkingUser(userId);
 
  Future<void> _addSettings(XSettings xsettings) => xapi.addToDatabaseSetting(xsettings);

  Future<String> logInUser(String email, String password, context) => xapi.signIn(email, password, context); 

  Future<XUser>  getUserFirestore(String userId) => xapi.getUserFromFirestore(userId); 

  Future<XSettings> getSettingsFirestore(String settingsId)  =>  xapi.getSettingsFirestore(settingsId);

  Future<FirebaseUser> getCurrentFirebaseUser() => xapi.getCurrentFirebaseUser();

  static Future<String> storeUserInfoLocal(XUser user) => XApi.storeUserInfoToLocal(user); 

  Future<String> storeSettingsLocal(XSettings settings) =>xapi.storeSettingsLocal(settings);

  Future<XUser> getUserLocal() => xapi.getUserLocal();

  Future<XSettings> getSettingsLocal() => xapi.getSettingsLocal();

  Future<void> logOutUser(context) => xapi.logOutUser(context);

  Future<void> forgotPasswordEmail(String email) => xapi.sendPassword(email);

  Future<String> uploadProfileImage(File file, String location) => xapi.uploadProfileImage(file,location); 

  //FOR EVENT
  Future<void> addEventDatabase(XEvent xevent) =>  _eventApi.addEventToDatabase(xevent);

  Future<void> addLocationDatabase(XLocation xlocation) => _eventApi.addLocationToDatabase(xlocation);

  Future<String> uploadImage(File image, String name) => _eventApi.uploadImage(image, name);

  Future<String> getImageUrl(String textImageLocation) => _eventApi.getImageUrl(textImageLocation); 

  Future<List<XEvent>> fetchAllEvents(FirebaseUser user) => _eventApi.fetchAllEvents(user); 

  Future<XLocation> getLocationFromId(String id) => _locationApi.getLocationFromId(id); 

  Future<List<XLocation>> fetchAllLocation(FirebaseUser user) => _locationApi.fetchAllLocation(user);

  //EXCEPTİONS
  String getExceptionText(Exception e) {
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
