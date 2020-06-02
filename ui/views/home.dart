import 'package:eventor/assets/my_custom_icons.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/state.dart';
import '../../core/services/state_widget.dart';
import '../../ui/views/sign_in.dart';
import '../../ui/widgets/loading.dart';
import '../widgets/side_bar_drawer.dart';

class XHomeScreen extends StatefulWidget {
  _XHomeScreenState createState() => _XHomeScreenState();
}

class _XHomeScreenState extends State<XHomeScreen> {
  //VAR
  XStateModel appState; 
  bool _loadingVisible = false;
  String img ;


  @override
  void initState() {
    super.initState();
  }

  String firstLetterCapitalize(String s){
    if(s == ""){
      return s;
    }
    
    return s[0].toUpperCase() + s.substring(1);
  }


  //DESİGN
  Widget build(BuildContext context) {



    appState = XStateWidget.of(context).state;  

    
      //database bilgileri alınıyor state classından 
      final userId = appState?.firebaseUserAuth?.uid ?? ''; 
      print("not:home: appState?.firebaseUserAuth?.uid ?? : userid ${appState?.firebaseUserAuth?.uid ?? ''}");
      final email = appState?.user?.email ?? '';
      final img = appState?.user?.imageUrl ?? '';
      final firstName = appState?.user?.firstName ?? '';
      final lastName = appState?.user?.lastName ?? '';
      final settingsId = appState?.settings?.settingsId ?? '';
      final userIdLabel = Text('App Id: ');
      final emailLabel = Text('Email: ');
      final firstNameLabel = Text('First Name: ');
      final lastNameLabel = Text('Last Name: ');
      final settingsIdLabel = Text('SetttingsId: ');  

      //print("iimmgg  $img");

      //DESİGN
      final logo = Column(
        children: [
          Hero(
            tag: 'hero',
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 80.0,
                child: ClipOval(
                  child: img == "" ? Image.asset(
                    'assets/images/default.png',
                    fit: BoxFit.cover,
                    width: 160.0,
                    height: 160.0,
                  ) : Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: 180.0,
                    height: 180.0, 
                  )
                )),
          ),
          SizedBox(height: 8,),
          Text(
            " ${firstLetterCapitalize(firstName)} ${firstLetterCapitalize(lastName)}",
            style: TextStyle(
              fontSize: 20
            ),
          )
        ],
      );
      

      Widget myTickets(String myText, IconData myIcon , String val){
        return Row(
          children: [
            Container(
              child:Padding(
                padding: EdgeInsets.all(1),
                child: Icon( 
                  myIcon,
                  color: Colors.blueGrey,
                  size: 20,
                ),
              ),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                )
              ),
            ),
            SizedBox(width: 8,),
            Text(
              myText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.blueGrey
              ),
            ),
            Spacer(),
            Text(
              val,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.blueGrey
              ),
            ),
          ],
        );

      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title:  Text(""), backgroundColor: Colors.blueGrey),
        drawer: new XSideBarDrawer(firstName,lastName,email), //sidebarDrawer
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
                      SizedBox(height: 40.0),
                      myTickets("My Tickets", MyCustomIcons.ticket, "5"), 
                      Divider(thickness: 2,height: 30,),
                      myTickets("My Events", MyCustomIcons.events, "2"),
                      Divider(thickness: 2,height: 30,),
                      myTickets("My Follows", MyCustomIcons.follow, "10"),
                      Divider(thickness: 2,height: 30,),
                      myTickets("My Favorites", MyCustomIcons.favorite,"4"),
                      Divider(thickness: 2,height: 30,),
                      myTickets("History", MyCustomIcons.history, "20"),
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
