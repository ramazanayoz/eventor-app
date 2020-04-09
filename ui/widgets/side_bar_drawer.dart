
import 'package:eventor/assets/my_custom_icons.dart';
import 'package:eventor/denem9-firebaseTum/core/viewsmodels/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/home.dart';
import '../widgets/bottom_navigation_widget.dart';

class XSideBarDrawer extends StatelessWidget{
  
  //CONSTRUCTUR
  final String firstName;
  final String lastName;
  final String email;
  XSideBarDrawer(this.firstName, this.lastName, this.email);
  

  //VAR
  String mainProfilePicture = 'https://i.pinimg.com/originals/2e/2f/ac/2e2fac9d4a392456e511345021592dd2.jpg';
  String boxDecorationImage = "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/blue-welcome-church-video-poster-template-df977a81710d4201a1a2a6546958ea54_screen.jpg?ts=1567088234";
  
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(firstName+" "+lastName), 
              accountEmail: Text(email),
              currentAccountPicture: new GestureDetector(
                onTap: () => print("This is the current user"),
                child: CircleAvatar(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.black,
                //  backgroundImage: new NetworkImage(mainProfilePicture),
                  radius: 35.0,
                  child: Text(firstName[0].toUpperCase(), style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 40.0),),
                ),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(boxDecorationImage),
                ),
              ),
            ),
            new ListTile(
              title: Text("Create Event"),
              trailing: Icon(Icons.add, color: Colors.blue),
              onTap: (){ 
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/event-create');
              },
            ),
            new ListTile(
              title: Text("Home"),
              trailing: Icon(Icons.home, color: Colors.blueAccent),
              onTap: (){ 
                Navigator.of(context).pop();
                //Navigator.pushNamed(context, '/');
              },           
            ),
            new ListTile(
              title: Text("Bookings"),
              trailing: Icon(Icons.book, color: Colors.blueAccent),
              onTap: (){ 
                Navigator.of(context).pop();
              },            
            ),
            new ListTile(
              title: Text("Payments"),
              trailing: Icon(Icons.payment, color: Colors.blueAccent),
              onTap: (){ 
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new XHomeScreen()));
              },             ),
            new ListTile(
              title: Text("Contact Us"),
              trailing: Icon(Icons.contact_mail, color: Colors.blueAccent),
              onTap: (){  
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new XHomeScreen()));
              },             ),
            new ListTile(
              title: Text("About Us"),
              trailing: Icon(MyCustomIcons.aboutUs),
              onTap: (){ 
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new XHomeScreen()));
              },             ),
            new ListTile(
              title: Text("Privacy Policy"),
              trailing: Icon(MyCustomIcons.privacyPoliticy),
              onTap: (){ 
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => new XHomeScreen()));
              },             ),
            new Divider(),
            new ListTile(
              title: new Text("Sign Out"),
              trailing: Icon(Icons.cancel),
              onTap: (){ 
                Provider.of<XAuthModel>(context).logOutUser(context);
                Navigator.of(context).pop();
              },             ),
          ],
        ),
      );
  }

}