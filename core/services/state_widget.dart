import 'dart:async';
import 'package:eventor/denem9-firebaseTum/core/resources/firebase_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/state.dart';
import '../models/user.dart';
import '../models/settings.dart';

class XStateWidget extends StatefulWidget {
  final XStateModel state;
  final Widget child;

  XStateWidget({  //constructur
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _XStateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
            as _StateDataWidget)
        .data;
  }

  @override
  _XStateWidgetState createState() => new _XStateWidgetState();
}

class _XStateWidgetState extends State<XStateWidget> {
  XStateModel state;
  //GoogleSignInAccount googleAccount;
  //final GoogleSignIn googleSignIn = new GoogleSignIn();
  XAuthModel _xAuthModel = XAuthModel();

  @override
  void initState() {
    super.initState();
    //print('not:XStateWidget da...initState... working');
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new XStateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
   // print('not:XStateWidget da...initUser... working');
    FirebaseUser firebaseUserAuth = await _xAuthModel.getCurrentFirebaseUser(); //şuanki kullanıcıya ulaş
    XUser user = await _xAuthModel.getUserLocal(); //telefona kaydedilmiş giriş bilgisi alınıyot
    XSettings settings = await _xAuthModel.getSettingsLocal(); //yerel ayarları al
    setState(() {
      state.isLoading = false;
      state.firebaseUserAuth = firebaseUserAuth;
      state.user = user;
      state.settings = settings;
    });
  }

  Future<void> ChangeStateForlogOutUser(firebaseUserAuth) async {
    setState(() {
      state.user = null;
      state.settings = null;
      state.firebaseUserAuth = firebaseUserAuth; //firebaseUserAuth null olarak ayrlandı 
    });
  }



  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _XStateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
