import 'package:eventor/denem9-firebaseTum/core/models/category.dart';
import 'package:eventor/denem9-firebaseTum/core/services/app_state.dart';
import 'package:eventor/denem9-firebaseTum/ui/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XCategoryWidget extends StatelessWidget {
  //VAR
  final XCategory category;
  //CONSTRUCTUR
  const XCategoryWidget({Key key, this.category}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    
    //VAR
    final _appState = Provider.of<XAppState>(context); 
    final _isSelected = _appState.selectedCategoryName == category.name; //PROVİDER SAYESİNDE BU KISIM DEĞİŞİNCE BUNA BAĞLI VERİABLE LARDA DEĞİŞİR VE PROĞRAM YENİ DEĞER GÖSTERİR
    print("selected category id: ${_appState.selectedCategoryName}");
    print("created category object, ${category.name}");
    //DESİGNS
    return  GestureDetector(
      onTap: (){
        if (!_isSelected) {
          _appState.updateCategoryId(category.name); 
          //notify edilir ve tüm category kısmı yeniden renderlenir 
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: _isSelected ? Colors.white : Color(0x99FFFFFF), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color:  _isSelected ? Colors.white: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              category.icon,
              color: _isSelected ? Theme.of(context).primaryColor : Colors.white,
              size: 40,
            ),
            new SizedBox(height: 10,),
            new Text(
              category.name,
              style: _isSelected ? selectedCategoryTextStyle : categoryTextStyle,
            )
          ],
        ),
      )
    );
  }
}