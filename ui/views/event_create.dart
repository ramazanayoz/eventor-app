import 'dart:io';

import 'package:eventor/denem9-firebaseTum/core/models/category.dart';
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:eventor/denem9-firebaseTum/core/models/state.dart';
import 'package:eventor/denem9-firebaseTum/core/models/user.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/firebase_methods.dart';
import 'package:eventor/denem9-firebaseTum/core/services/state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../widgets/date_notification_dialog.dart';

class XEventCreate extends StatefulWidget {
  @override
  _XEventCreateState createState() => _XEventCreateState();
}

class _XEventCreateState extends State<XEventCreate> with SingleTickerProviderStateMixin  {
  //VAR
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _startDate = new TextEditingController();
  final TextEditingController _endDate = new TextEditingController();
  final TextEditingController _price = new TextEditingController();
  final TextEditingController _city = new TextEditingController();
  final TextEditingController _state = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  final TextEditingController _instructur = new TextEditingController();
  final TextEditingController _maxParticipent = new TextEditingController();
  final TextEditingController _briefDescription = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

  bool _status = false;
  final FocusNode myFocusNode = FocusNode();

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();  
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd     HH:mm');
  File _image;  

  List<XCategory> _categorieslist = XCategory.getCategories();
  List<DropdownMenuItem<XCategory>> _dropdownMenuItemslist;
  XCategory _selectedCategory;

  XAuthModel _authModel = XAuthModel();

  //FUNCT 
  @override
  void initState() {
    // TODO: implement initState
    _dropdownMenuItemslist = _buildDropdownMenuItems(_categorieslist);
    _selectedCategory = _dropdownMenuItemslist[0].value;
    super.initState();
  }

  List<DropdownMenuItem<XCategory>> _buildDropdownMenuItems(List categorieslist){
    List<DropdownMenuItem<XCategory>> itemslist = List();
    for(XCategory xcategories in categorieslist){
      itemslist.add(
        DropdownMenuItem(value: xcategories, child:Text(xcategories.name), ),
      );
    }
    return itemslist;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Future getImageFromGallery()  async { //for gallery image pick up
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future onChangeDropdonItem(XCategory selectedCategory){
    setState(() {
      _selectedCategory = selectedCategory;
    });
  }

  void _createEvent({String name, String category, String startDate, String endDate, String price, String city, String state, String address, String instructur, String maxParticipant, String briefDescription, String description, BuildContext context }) async{
    try{
      SystemChannels.textInput.invokeMethod("TextInout.hide");
       XStateModel appState = await XStateWidget.of(context).state; 

      String imageUrl;
      String imageLocation;
      if(_image != null){
         imageLocation = await _authModel.uploadImage(_image, name);
         imageUrl = await _authModel.getImageUrl(imageLocation,);
      }

      
     // print("kasda:" +imageUrl+ " asdasd:"+ imageLocatin);

       await _authModel.addEventDatabase(new XEvent(
          userId: appState.user.userId,  
          imageLocation: imageLocation,
          imageUrl: imageUrl,
          name: name,
          category: category,
          startDate: startDate,
          endDate: endDate,
          price: price, 
          instructur : instructur, 
          maxParticipant : maxParticipant, 
          briefDescription : briefDescription, 
          description: description
       ));
       
       await _authModel.addLocationDatabase(new XLocation( 
         city: city,
         state: state,
         address: address,
       ));

    }catch(e){
        print("Create Event Error: $e");
    }

  }



  //DESİGNS
  Widget createTitleInput(String _titleField){
        return Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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

  Widget createTextInput( String _hintText, TextEditingController _textEditingController ){
        return Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: new TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: _hintText ,
                  ),
                  enabled: !_status,
                  autofocus: !_status,
                ),
              ),
            ],
          )
        );
  } 
  
 Widget createDescriptionInput( {String hintText, TextEditingController textEditingController, int maxlines} ){
        return Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: new TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: maxlines,
                  decoration: InputDecoration(
                    hintText: hintText ,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, 
                        width: 5.0
                      ),
                    ),
                  ),
                  enabled: !_status,
                  autofocus: !_status,
                ),
              ),
            ],
          )
        );
  }  


  @override
  Widget build(BuildContext context) {

  //DESİGN
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
                  _createEvent(
                    name: _name.text,
                    category: _selectedCategory.name,
                    startDate: _dateFormat.format(_selectedStartDate),
                    endDate: _dateFormat.format(_selectedEndDate),
                    price: _price.text,
                    city: _city.text,
                    state: _state.text,
                    address: _address.text,
                    instructur: _instructur.text,
                    maxParticipant: _maxParticipent.text,
                    briefDescription: _briefDescription.text,
                    description: _description.text,
                    context: context,
                  );
                  Navigator.of(context).pop();
                  setState(() {
                    _status = false;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
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
                  Navigator.of(context).pop();
                  setState(() {
                   // _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
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

  Widget _getEditIcon() {
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
        setState(() {
          _status = true;
        });
      },
    );
  }  
  Widget headerBackButtonWid(){
    return Padding(
      padding: EdgeInsets.only(left:10.0, top: 20.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
            new Row(
              children: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 22.0,
                  ), 
                  onPressed: (() => Navigator.of(context).pop()),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: new Text(
                    'CREATE EVENT',
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

        ],
      )
    );
  }

  Widget headerProfileWid(){
    return Padding(
      padding: EdgeInsets.only(top: 2.0),
      child: Stack(fit: StackFit.loose, 
              alignment: Alignment.bottomRight,

        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: Center(
              child: _image==null ? Text('No Image selected') : Image.file(_image, fit: BoxFit.fitWidth,),
              
            ),
          ),
          Row( 

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: getImageFromGallery,
                  tooltip: 'Pick Image',
                  mini: true,
                  child: Icon(Icons.wallpaper),
                  ),
              ],
            ),
        ]
      ),
    );
  }

  Widget titleFieldWid(){
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
                  'Fill the Form',
                  style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              false ? _getEditIcon() :  Container(),
            ],
          ),
        ],
      )
    );
  }

  Widget eventNameFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Event Name"),
        createTextInput("Name...", _name),
      ]
    );    
  }

  Widget categoryWid(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        createTitleInput("Select a category"),
        Container(
          margin: EdgeInsets.only(left: 28),
          child: DropdownButton(
            value: _selectedCategory,
            items: _dropdownMenuItemslist, 
            onChanged: onChangeDropdonItem,
          ),
        ),
      ],
    );
  }

  Widget startDateFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Start Date and Time"),
        new Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
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
                        setState(() {
                          this._selectedStartDate = selectedDate;
                        });
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


  Widget endDateFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("End Date and Time"),
        Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
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
                        setState(() {
                          this._selectedEndDate = selectedDate;
                        });
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

    Widget priceFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Price"),
        createTextInput("Price...", _price),
      ]
    ); 
  }

  Widget cityFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("City"),
        createTextInput("City...", _city),
      ]
    );    
  }

  Widget stateFieldWid(){
    return Column(    
      children: <Widget>[
        createTitleInput("State"),
        createTextInput("State...", _state),
      ]
    );          
  }

  Widget addressFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Address"),
        createTextInput("Address...", _address ),
      ]
    );           
  }

  Widget insctructurFieldWid(){
    return Column(       
       children: <Widget>[
        createTitleInput("Insctructur"),
        createTextInput("Insctructur...", _instructur),
      ]
    );  
  }

  Widget maxParticipantFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Max Participant"),
        createTextInput("Max Participant...", _maxParticipent),
      ]
    );          
  }

  Widget briefDescriptionFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Brief Description"),
        createDescriptionInput(hintText:"Brief Description...", textEditingController: _briefDescription, maxlines:3 ),
      ]
    );    
  }


  Widget descriptionFieldWid(){
    return Column(
      children: <Widget>[
        createTitleInput("Description"),
        createDescriptionInput(hintText:"Description...",  textEditingController: _description, maxlines:9),
      ]
    );
  }

 

    return new Scaffold(
      body: new Container(
      color: Colors.white,
      child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 250.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    headerBackButtonWid(),
                    headerProfileWid(),
                  ],
                ),
              ),
              new Container(
                color: Color(0xffFFFFFF),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        titleFieldWid(),
                        eventNameFieldWid(),
                        categoryWid(),
                        startDateFieldWid(),
                        endDateFieldWid(),
                        priceFieldWid(),
                        cityFieldWid(),
                        stateFieldWid(),
                        addressFieldWid(),
                        insctructurFieldWid(),
                        maxParticipantFieldWid(),
                        briefDescriptionFieldWid(),
                        descriptionFieldWid(),
                        !_status ? _getActionButtons() :  _getActionButtons(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

}