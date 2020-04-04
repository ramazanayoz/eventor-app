import 'package:eventor/denem9-firebaseTum/util/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../ui/screens/sign_in.dart';
import '../../ui/widgets/loading.dart';

class XHomeScreen extends StatefulWidget {
  _XHomeScreenState createState() => _XHomeScreenState();
}

class _XHomeScreenState extends State<XHomeScreen> {
  //VAR
  XStateModel appState;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }
  //DESİGN
  Widget build(BuildContext context) {

    appState = XStateWidget.of(context).state;

    //home ekranında user bilgileri yoksa direk signin ekranına geç
    if (!appState.isLoading &&    //bunlar yerine gelmediyse signin'e geç
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      //database bilgileri alınıyor state classından 
      final userId = appState?.firebaseUserAuth?.uid ?? ''; 
      print("not:home: appState?.firebaseUserAuth?.uid ?? : userid ${appState?.firebaseUserAuth?.uid ?? ''}");
      final email = appState?.firebaseUserAuth?.email ?? '';
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final settingsId = appState?.settings?.settingsId ?? '';
      final userIdLabel = Text('App Id: ');
      final emailLabel = Text('Email: ');
      final firstNameLabel = Text('First Name: ');
      final lastNameLabel = Text('Last Name: ');
      final settingsIdLabel = Text('SetttingsId: ');  

      //DESİGN
      final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60.0,
            child: ClipOval(
              child: Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ),
            )),
      );

      final signOutButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
           // XStateWidget.of(context).logOutUser();
            Provider.of<XAuth>(context).logOutUser(context);
          },
          padding: EdgeInsets.all(12),
          color: Theme.of(context).primaryColor,
          child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
        ),
      );

      return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingScreen(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      userIdLabel,
                      Text(userId,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      emailLabel,
                      Text(email,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      firstNameLabel,
                      Text(firstName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      lastNameLabel,
                      Text(lastName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      settingsIdLabel,
                      Text(settingsId,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.0),
                      signOutButton,
                      //signInLabel,
                      //signUpLabel,
                     // forgotLabel
                    ],
                  ),
                ),
              ),
            ),
            inAsyncCall: _loadingVisible),
      );
    }
  }
}
