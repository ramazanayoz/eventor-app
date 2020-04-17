import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/core/services/state_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class XApi{
  //var
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;
  
  //CONSTRUCTUR
  XApi(this.path){
    ref = _db.collection(path);
  }

  //FUNCT
  Future<String> createUser(email,password) async {
  AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid ;
  } 

  Future<String> signIn(email,password, context) async {
    AuthResult authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    String userId = authResult.user.uid;
    XUser user = await getUserFromFirestore(userId); //XUser nesnesi oluşturuluyor firebaseden alınan verilerle
    await storeUserInfoLocal(user); //user bilgileri string olarak telefolna depolanır
    XSettings settings = await getSettingsFirestore(userId);
    await storeSettingsLocal(settings);
    XStateWidget.of(context).initUser();
  }


   Future<XSettings> getSettingsFirestore(String settingsId) async {
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

  Future<FirebaseUser> getCurrentFirebaseUser() async {
    print("not:auth: getCurrentFirebaseUser fonk");    
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }



  
  Future<XUser> getUserFromFirestore(String userId) async {
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

  //ADDİNG DATABASE 
  Future<void> addToDatabaseUser(XUser xuser) async {
    checkingUser(xuser.userId).then((userId) async {
       if(!userId) {
        await Firestore.instance
            .document("users/${xuser.userId}")
            .setData(xuser.classObjConvertToJson());//alınan bilgiler json yani map formata çevrilir database eklemek için

            addToDatabaseSetting(new XSettings(
                settingsId: xuser.userId,
              ));
            } else {
              print("user ${xuser.firstName} ${xuser.email} exists");
            }        
    });
  }

  Future addUserSettingsDB(XUser xuser) async {  //kullanıcı firebase db kaydediliyor
    checkingUser(xuser.userId).then((value) async {
      if (!value) {
        print("user ${xuser.firstName} ${xuser.email} added");
        print("not auth: user.toJson(): ${xuser.classObjConvertToJson()}");
        
        await addToDatabaseUser(xuser); //alınan bilgiler json yani map formata çevrilir database eklemek için
        
        addToDatabaseSetting(new XSettings(
          settingsId: xuser.userId,
        ));
      } else {
        print("user ${xuser.firstName} ${xuser.email} exists");
      }
    });
  } 



  Future<void> addToDatabaseSetting(XSettings xsettings) async {    
    Firestore.instance
        .document("settings/${xsettings.settingsId}")
        .setData(xsettings.convertToJsonMap()); //firebase eklemek için fjson yani map formata çevriliyor    
    
    print("not: Xauth _addSettings fonc working");
    print("not: auth:  settings.toJson(): ${xsettings.convertToJsonMap()}");
  }

  //USER EXİSTİNG CHECKİNG 
  Future<bool> checkingUser(userId) async{
    bool exists;
    try {
      await Firestore.instance.document("users/$userId").get().then((DocumentSnapshot docSnapshot){
        if(docSnapshot.exists)
          exists = true;
        else
          exists = false;
      });

      return exists;

    } catch(e) {
        return false;
    }

  }  




  //SAVİNG USER INFO TO lOCAL STRAGE
  Future<String> storeUserInfoLocal(XUser user) async {
    //print(":auth: storeUserLocal(XUser user) fonk working");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = classObjConvertToJsonString(user);
    //print("---:storeUser var: $storeUser");
    await prefs.setString('user', storeUser);
    return user.userId;
  }

  Future<String> storeSettingsLocal(XSettings settings) async { //kullanıcı adı gibi bilgiler telefona yerel olarak kaydetme
    print("not:auth: storeSettingsLocal(XSettings settings) fonk");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeSettings = settingsObjectToJsonString(settings);
    print(" storeSettings var ${storeSettings}");
    await prefs.setString('settings', storeSettings);
    return settings.settingsId;
  }

  //GETTİNG USER INFO FROM lOCAL STRAGE
  Future<XUser> getUserLocal() async { //tekrar kullanıcı parala kgirmesin diye depolanan yerden kullanıcı ayaralrı alma
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

  Future<XSettings> getSettingsLocal() async {
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



  Future<void> sendPassword(email) async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}

 