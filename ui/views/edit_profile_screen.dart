import 'dart:io';
import 'dart:ui';

import 'package:eventor/denem9-firebaseTum/core/models/state.dart';
import 'package:eventor/denem9-firebaseTum/core/models/user.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/firebase_methods.dart';
import 'package:eventor/denem9-firebaseTum/core/services/editProfile_provider.dart';
import 'package:eventor/denem9-firebaseTum/core/services/state_widget.dart';
import 'package:eventor/denem9-firebaseTum/core/services/validator.dart';
import 'package:eventor/deneme21-ui-event/constant/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class XEditProfileScreen extends StatelessWidget {
  
  final BuildContext context;
  XEditProfileScreen({Key key, this.context}) : super(key: key);

  //VAR
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  File _image;
  String _imageUrl="";
  XEditProfileProvider editProfileProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController(); 
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _currentPassword = new TextEditingController();
  final TextEditingController _newPassword = new TextEditingController();
  final TextEditingController _phoneNumber = new TextEditingController();

  FirebaseUser _currentUser;

  String _imageLocation;

/*
  //FUNCT 
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    
    //dispose method use to release the memory allocated to variables when state object is removed.
    //For example, if you are using a stream in your application then you have to release memory
    // allocated to streamController. Otherwise your app may get warning from playstore and appstore about memory leakage.
    myFocusNode.dispose();
    super.dispose();
  } 

*/


  //FUNCT
  getImageFromGallery() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(_image != null){ 
      editProfileProvider.changeImagePic(_image);
    }
  }

void makeNotify(){
    Provider.of<XEditProfileProvider>(context).makeNotify();
  }

  getCurrentUser() async {
    XFirebaseMethod _xFirebaseMethod = new XFirebaseMethod();
    _currentUser =  await _xFirebaseMethod.getCurrentFirebaseUser().then((firebaseUser) => firebaseUser);

  }

  initializeInputes() async{
    XFirebaseMethod _xFirebaseMethod = new XFirebaseMethod();
    _currentUser =  await _xFirebaseMethod.getCurrentFirebaseUser().then((firebaseUser) => firebaseUser);
    print("photo url  ${_imageUrl}" );
    _firstName.text = _currentUser?.displayName?.split(".")[0];
    print("_firstName.text ${_firstName.text}");
    _lastName.text = _currentUser?.displayName?.split(".")[1];
    _email.text = _currentUser?.email;
    _phoneNumber.text = _currentUser?.phoneNumber;
  }

  saveToDb() async{
    try{
    print("savetodb fonk working");
    AuthCredential authCredential = EmailAuthProvider.getCredential(email:_currentUser.email, password:_currentPassword.text);
    if(_currentPassword.text != _newPassword.text || _currentPassword.text.trim() == "" ){
      if(authCredential != null || _newPassword.text.trim() == "" ){ 
        XFirebaseMethod firebaseMethod = XFirebaseMethod();
        if(_image != null){
          _imageLocation = "images/profile-photo/${_currentUser.displayName}-${_currentUser.uid}.jpg";
          _imageUrl = await firebaseMethod.uploadProfileImage(_image, _imageLocation);
        }
        XUser user = XUser(
          userId: _currentUser.uid, 
          firstName: _firstName.text, 
          lastName: _lastName.text, 
          email: _email.text, 
          phoneNumber: _phoneNumber.text,
          imageUrl: _imageUrl,
          imageLoc: _imageLocation
        );
        await firebaseMethod.updateProfileInfo(user, _currentPassword.text, _newPassword.text, context);
        await XFirebaseMethod.storeUserInfoLocal(user);
        editProfileProvider.imageUrl= _imageUrl; 
        XStateWidget.of(context).state.user = user;  

        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/');
      }
    }else{
      print("paswords already same different");
      throw("New password must be different from current password");
    }
    }catch(e){ 
      
      print("eerror $e");
      Flushbar(
        title: "Error",
        message: "$e",
        duration: Duration(seconds: 5),
      )..show(this.context);
    
      
    }
  }

  


  //DESİGN
  @override
  Widget build(BuildContext context) {

    getCurrentUser();
    initializeInputes();
    

    //VAR
    editProfileProvider =Provider.of<XEditProfileProvider>(context);

    //image initiliaze
    XStateModel appState = XStateWidget.of(context).state;  
    _imageUrl = appState.firebaseUserAuth.photoUrl;
    if(editProfileProvider.imageUrl != null){
      _imageUrl = editProfileProvider.imageUrl;
    }

    print("edit profile screen working");
    print("imageurl ${_imageUrl}");
    print("imageUrl ${editProfileProvider.imageUrl}");
    return new Scaffold(
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 260.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        headerBackButtonWid(),
                        Consumer<XEditProfileProvider>(
                          builder: (context, xeditProviderScreen, child){
                            return headerProfileWid( context);
                          },
                        ) 
                      ],
                    ),
                  ),
                  new Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Form(
                        key: _formKey,
                        autovalidate: true,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            createNewEventWid(),
                            firstNameFieldWid(),
                            lastNameFieldWid(),
                            emailFieldWid(),
                            mobileFieldWid(),
                            currentPassFieldWid(),
                            Consumer<XEditProfileProvider>(
                              builder: (context, xeditProfileProvider, child){
                                return !xeditProfileProvider.isActiveTextInput ? new Container() 
                                  :Column(
                                    children: <Widget>[
                                      newPassFieldWid(),
                                      _getActionButtons()
                                    ],
                                  ) ;
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }


  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  saveToDb();
              //    setState(() {
                //    _status = true;
                  //  FocusScope.of(context).requestFocus(new FocusNode());
              //    }); 
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  Provider.of<XEditProfileProvider>(context).switchTextInputActiviness();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon(BuildContext context) {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        Provider.of<XEditProfileProvider>(context).switchTextInputActiviness();
        
      },
    );
  }  

  
  Widget headerBackButtonWid(){
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 20.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 22.0,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: new Text(
              'PROFILE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'sans-serif-light',
                color: Colors.black
              )
            ),
          )
        ],
      )
    );
  }

  Widget headerProfileWid(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Container(
            constraints: BoxConstraints.expand( height: 190,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(3, 3), // changes position of shadow
                ),
              ],
            ),
            child:Flex(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Stack(
                    fit: StackFit.loose, 
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[     
                              Consumer<XEditProfileProvider>(
                                builder: (context, xeditProfileProvider, child){
                                  return new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: _image != null  
                                          ? new FileImage(_image) : _imageUrl == "" ? new ExactAssetImage( 'assets/images/as.png' ): NetworkImage(_imageUrl) ,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  );
                                }
                              )
                            ],
                          )
                        ],
                      ),
                      editProfileProvider.isActiveTextInput == false ? Container()
                      :Padding(
                        padding: EdgeInsets.only(top: 90.0, right: 100.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: getImageFromGallery,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 25.0,
                                child: new Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    ]
                  ),
              ], direction: Axis.horizontal,
            ),      
      )
    );
  }

  Widget createNewEventWid(){
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                Text(
                  'Profil Information',
                  style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Consumer<XEditProfileProvider>(
                builder: (context, xeditProfileProvider, child){
                return !xeditProfileProvider.isActiveTextInput ? _getEditIcon(context) : new Container();
                },
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget firstNameFieldWid(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'First Name',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: Consumer<XEditProfileProvider>(
                  builder: (context, xeditProfileProvider, child){
                    return TextFormField(
                      controller: _firstName,
                      validator: Validator.validateName ,
                      enabled: xeditProfileProvider.isActiveTextInput,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: "Enter Your Name",
                      ),
                    );
                  },
                )
              ),                          
            ],
          )
        ),
      ]
    );
  }

  Widget lastNameFieldWid(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'Last Name',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: Consumer<XEditProfileProvider>(
                  builder: (context, xeditProfileProvider, child){
                    return TextFormField(
                      controller: _lastName,
                      validator: Validator.validateName ,
                      enabled: xeditProfileProvider.isActiveTextInput,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: "Enter Your Name",
                      ),
                    );
                  },
                )
              ),                          
            ],
          )
        ),
      ]
    );
  }

  Widget emailFieldWid(){
    return Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                ],
              ),
            ],
          )
        ),
        new Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: Consumer<XEditProfileProvider>(
                  builder: (context, xeditProfileProvider, child){
                    return TextFormField(
                      controller: _email,
                      validator: Validator.validateEmail,
                      decoration: const InputDecoration(
                        hintText: "Enter Email ID"
                      ),
                      enabled: false,
                    );
                  }
                )
              ),
            ],
          )
        ),
      ],
    );
  }

  Widget mobileFieldWid(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child:Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'Mobile',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: Consumer<XEditProfileProvider>(
                  builder: (context, xeditProfileProvider, child){
                    return  TextFormField(
                      controller: _phoneNumber,
                      //initialValue: "     ",
                      //validator: Validator.validatePassword,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: "Enter Mobile Number"
                      ),
                      enabled: xeditProfileProvider.isActiveTextInput,
                    );
                  }
                )
              ),
            ],
          )
        ), 
      ],
    );
  }


  Widget currentPassFieldWid(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child:Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'Current Password',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: Consumer<XEditProfileProvider>(
                  builder: (context, xeditProfileProvider, child){
                    return  TextFormField(
                      obscureText: true,
                      controller: _currentPassword,
                      validator: _currentPassword.text.trim() != ""? Validator.validatePassword: null,
                      enabled: xeditProfileProvider.isActiveTextInput,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: '\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf'
                      ),
                    );
                  }
                )
              ),
            ],
          )
        ), 
      ],
    );
  }  

  Widget newPassFieldWid(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child:Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: Consumer<XEditProfileProvider>(
                  builder: (context, xeditProfileProvider, child){
                    return  TextFormField(
                      obscureText: true,
                      controller: _newPassword,
                      //initialValue: "     ",
                      validator: _newPassword.text.trim() != ""? Validator.validatePassword: null,
                      enabled: xeditProfileProvider.isActiveTextInput,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: '\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf\u25cf'
                      ),
                    );
                  }
                )
              ),
            ],
          )
        ), 
      ],
    );
  }  


}