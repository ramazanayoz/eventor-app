import 'dart:convert';
import 'dart:io';

import 'package:eventor/denem9-firebaseTum/core/models/category.dart';
import 'package:eventor/denem9-firebaseTum/core/services/eventForm_provider.dart';
import 'package:eventor/denem9-firebaseTum/core/services/validator.dart';
import 'package:eventor/denem9-firebaseTum/ui/widgets/date_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';

class XFirstStep extends StatefulWidget {

  final bool isAutoValidate;
  const XFirstStep({ Key key, this.isAutoValidate}): super(key: key);

  @override
  _XFirstStepState createState() => _XFirstStepState();
}

class _XFirstStepState extends State<XFirstStep> {

  //VAR
  
  bool _status = false;
  final TextEditingController _title = new TextEditingController();

  File _image; 
  List _myCategoryList;
  String _selectedCategories;

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();  
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  XEventFormProv _eventFormProv;


  Future getImageFromGallery()  async { //for gallery image pick up
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = image;
        _eventFormProv.imageFile = image;
      });
    }
  } 


  @override
  Widget build(BuildContext context) {
     print("initState working");

  //VAR
    _eventFormProv =  Provider.of<XEventFormProv>(context);

    //İNİTSTATE FOR NOT LOSİNG DATA IN REFRESHİNG 
    _title.text =  _eventFormProv.title;    
    _image = _eventFormProv.imageFile ?? null;
    _myCategoryList = _eventFormProv.myCategoryList;  
    print(_eventFormProv.startDate);
    try{ _selectedStartDate = DateFormat('yyyy-MM-dd HH:mm').parse(_eventFormProv.startDate); }catch(e){ print(e); };  
    try{ _selectedEndDate = DateFormat('yyyy-MM-dd HH:mm').parse(_eventFormProv.endDate); }catch(e){ print(e); };  
    _eventFormProv.startDate = _dateFormat.format(_selectedStartDate) ;
    _eventFormProv.endDate = _dateFormat.format(_selectedEndDate) ;
   
  //DESİGNS
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

    //START DATE FİELD WİD  
    Widget startDateFieldWid(){
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) { 
          return Column(
            children: <Widget>[
              createTitleInput("Start Date and Time"),
              new Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible( 
                      child: FlatButton(
                        onPressed: () {
                          showDateTimeDialog( 
                            context, 
                            initialDate: _selectedStartDate,
                            onSelectedDate: (selectedDate){  //void Function(DateTime) onSelectedDate ???
                            setState( () =>  this._selectedStartDate = selectedDate);
                            _eventFormProv.startDate = _dateFormat.format(_selectedStartDate);

                            }
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            new Text(
                              _dateFormat.format(_selectedStartDate),
                              style: TextStyle(color: Colors.blue),
                            ),
                            SizedBox(width: 5),
                            new Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          );
        }
      );

    }

    //END DATE FİELD WİD  
    Widget endDateFieldWid(){
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: <Widget>[
              createTitleInput("End Date and Time"),
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: FlatButton(
                        onPressed: () {
                          showDateTimeDialog(
                            context, 
                            initialDate: _selectedEndDate,
                            onSelectedDate: (selectedDate){  //void Function(DateTime) onSelectedDate ???
                              setState( () => this._selectedEndDate = selectedDate);
                              _eventFormProv.endDate = _dateFormat.format(_selectedEndDate);
                            }
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            new Text(
                              _dateFormat.format(_selectedEndDate),
                              style: TextStyle(color: Colors.blue),
                            ),
                            SizedBox(width: 5),
                            new Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ), 
            ],
          );
        }
      );
    }
   

  Widget createTextInput( String _hintText, TextEditingController _textEditingController, Function validator ){
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 2.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Flexible(
            child: new TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: _textEditingController,
              autovalidate: widget.isAutoValidate,
              validator: validator,
              decoration: InputDecoration(
                hintText: _hintText ,
              ),
              enabled: !_status,
              autofocus: !_status,
              onChanged: (val){
                Provider.of<XEventFormProv>(context).title = val;
                print("valll ${val}");
               // _eventFormProv.title =  val;
                print("valll2 ${_eventFormProv.title}"); 
              },
            ),
          ),
        ],
      )
    );
  } 




  //TİTLE WİDGET
  Widget eventTitleFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Event Title"),
        createTextInput("title...", _title, Validator.validateEventName), 
      ]
    );    
  }

  // CATEGORY WİDTET
  Widget categoryWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Category"),
        new Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child:StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState){
                    return MultiSelectFormField(
                      autovalidate:  widget.isAutoValidate,
                      titleText: "",
                      validator: (value){
                        value =  value ?? _eventFormProv.myCategoryList;
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
                      value: _myCategoryList ,
                        onSaved: (value) {
                          setState(() {
                            _myCategoryList = value;
                            _eventFormProv.myCategoryList = value;
                            this._selectedCategories = json.encode(value);
                            _eventFormProv.category = json.encode(value); 
                            print( "_selectedCategories ${_selectedCategories}");
                          });
                        },
                    );
                  },
                ) 
              ),
            ],
          ),
        ),
      ]
    );
  }

  //EVENT PİCTURE DESİGN METHOD
  Widget headerProfileWid(){
    return Padding(
      padding: EdgeInsets.only(top: 2.0),
      child: Stack(fit: StackFit.loose, 
              alignment: Alignment.bottomRight,

        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 140,
            child: Center(
              child: _image==null ? Text('No Image selected') : Image.file(_image, fit: BoxFit.fitWidth,),
              
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: getImageFromGallery,
                  tooltip: 'Pick Event Image',
                  mini: true,
                  child: Icon(Icons.wallpaper),
                  ),
              ],
            ),
        ]
      ),
    );
  }


  return Column( 
    children: <Widget>[
      headerProfileWid(),
      eventTitleFieldWid(),
      categoryWid(),
      startDateFieldWid(),
      endDateFieldWid(),
    ],
         
  );
  

  }
  
}