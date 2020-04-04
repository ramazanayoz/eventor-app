import 'package:eventor/denem9-firebaseTum/core/models/state.dart';
import 'package:eventor/denem9-firebaseTum/core/services/state_widget.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/sign_in.dart';
import 'package:flutter/material.dart';
//
import '../../ui/views/home.dart';
import '../../ui/views/category.dart';
import '../../ui/views/agenda.dart';
import '../../ui/views/tickets.dart'; 


class XBottomNavigationWidget extends StatefulWidget {
  @override
  _XBottomNavigationWidgetState createState() => _XBottomNavigationWidgetState();
}

class _XBottomNavigationWidgetState extends State<XBottomNavigationWidget> {
  //VARİABLES
  final _bottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> _list = List();
  
  XStateModel appState;
  bool _loadingVisible = false;

  //FUNCTİONS 
  @override
  void initState() {
    _list
      ..add(XHomeScreen())
      ..add(XCategoryScreen())
      ..add(XAgendaScreen())
      ..add(XTicketsScreen()); //listeye tek satırda eklemek farklı bir yol .. ile bağlantı yapıldı
    //print('_list: $_list'); 
    super.initState();
  }

  @override
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

      //DESİGNS
      return Scaffold(
        body: _list[_currentIndex],   //kaçıncı indexdeyse listeden o sayfaya geçiliyor gövde
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem( //1. kısım
              icon: Icon(
                Icons.home,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'HOME',
                style: TextStyle(color: _bottomNavigationColor),
              ),
            ),
            BottomNavigationBarItem( // 2.kısım
                icon: Icon(
                  Icons.email,
                  color: _bottomNavigationColor,
                ),
                title: Text(
                  'Email',
                  style: TextStyle(color: _bottomNavigationColor),
                )),
            BottomNavigationBarItem( //3.kısım
                icon: Icon(
                  Icons.pages,
                  color: _bottomNavigationColor,
                ),
                title: Text(
                  'PAGES',
                  style: TextStyle(color: _bottomNavigationColor),
                )),
            BottomNavigationBarItem( //5.kısım
                icon: Icon(
                  Icons.airplay,
                  color: _bottomNavigationColor,
                ),
                title: Text(
                  'AİRPLAY',
                  style: TextStyle(color: _bottomNavigationColor),
                )
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            //tıklandığında yana geçiş yapması için
            // kaçıncı indexe basıydıysa body ona geçer
            setState(() {
              _currentIndex = index;
              //print("_currentindex: $_currentIndex");
            });
          },
          //type: BottomNavigationBarType.fixed, // eğer animasyon istemiyorsak bar sabit kalsın istiyorsak  
        ),
      );
    }
  }
}
