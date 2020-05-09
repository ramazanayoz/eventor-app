import 'dart:convert';

import 'package:eventor/denem9-firebaseTum/core/models/category.dart';
import 'package:eventor/denem9-firebaseTum/core/services/eventForm_provider.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
class XCategoryWidget extends StatefulWidget {
     final List myCategoryList ;
  XCategoryWidget({Key key,  this.myCategoryList}) : super(key:key) ;

  @override
  _XCategoryWidgetState createState() => _XCategoryWidgetState(myCategoryList: this.myCategoryList);
}

class _XCategoryWidgetState extends State<XCategoryWidget>  with AutomaticKeepAliveClientMixin  {
  List myCategoryList;

  //List _myCategoryList=[];
  String _selectedCategories;
  XEventFormProv _eventFormProv;

  _XCategoryWidgetState({this.myCategoryList});

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

      _eventFormProv =  Provider.of<XEventFormProv>(context);

       Widget createTitleInput(String _titleField){
      return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 25.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  _titleField,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ],
        )
      );   
    }   


    return Column(
      children: <Widget>[
        createTitleInput("Category"),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: MultiSelectFormField(
                  autovalidate: true,
                  titleText: "",
                  validator: (value){
                    if(value ==null || value.length ==0){
                      return 'Please select one or more options';
                    }
                  },
                  dataSource: XCategory.getCatAsStringList(),
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintText: 'Please choose one or more',
                  value: this.myCategoryList,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        this.myCategoryList = value;
                        _eventFormProv.myCategoryList = value;
                        _eventFormProv.category = json.encode(value); 
                        print( "_selectedCategories ${_selectedCategories}");
                      });
                    },
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }
    @override
  bool get wantKeepAlive => true;
}