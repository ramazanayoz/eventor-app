
import 'package:eventor/denem9-firebaseTum/core/services/eventForm_provider.dart';
import 'package:eventor/denem9-firebaseTum/core/services/validator.dart';
import 'package:eventor/denem9-firebaseTum/ui/widgets/date_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class XSecondStep extends StatelessWidget {

  //VAR
  final TextEditingController _instructur = new TextEditingController();
  final TextEditingController _maxParticipent = new TextEditingController();
  final TextEditingController _price = new TextEditingController();
  final TextEditingController _briefDescription = new TextEditingController();
  final TextEditingController _description = new TextEditingController();

  bool _status = false;
  XEventFormProv _eventFormProv;
  

  @override
  Widget build(BuildContext context) {
    
    //VAR
    _eventFormProv =  Provider.of<XEventFormProv>(context);

    //İNİTSTATE FOR NOT LOSİNG DATA IN REFRESHİNG 
    _instructur.text = _eventFormProv.instructur ?? "";
    _maxParticipent.text = _eventFormProv.maxParticipant ?? "";
    _price.text = _eventFormProv.price ?? "";
    _briefDescription.text = _eventFormProv.briefDescription ?? "";
    _description.text = _eventFormProv.description ?? "";  

    //METHODS
    refresInputs(){
      _eventFormProv.instructur =  _instructur.text;
      _eventFormProv.maxParticipant = _maxParticipent.text;
      _eventFormProv.price = _price.text;
      _eventFormProv.briefDescription = _briefDescription.text;
      _eventFormProv.description = _description.text;
    }




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
                autovalidate: true,
                validator: validator,
                onChanged: (val){
                  refresInputs();
                },
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

    
    Widget createDescriptionInput( {String hintText, TextEditingController textEditingController, int maxlines, Function validator} ){
      return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: maxlines,
                onChanged: (val){
                  refresInputs();
                },
                autovalidate: true,
                validator: validator,
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
    
    //INSTRUCTUR FİELD WİD
    Widget insctructurFieldWid(){
      return Column(       
        children: <Widget>[
          createTitleInput("Insctructur"),
          createTextInput("Insctructur...", _instructur, Validator.validateName),
        ]
      );  
    }

    // PARTİCİPANT FİELD WİD
    Widget maxParticipantFieldWid(){
      return Column(
        children: <Widget>[
          createTitleInput("Max Participant"),
          createTextInput("Max Participant...", _maxParticipent, Validator.validateMaxParticipant),
        ]
      );
    }

    //PRİCE FİELD WİD
    Widget priceFieldWid(){
      return Column(
        children: <Widget>[
          createTitleInput("Price"),
          createTextInput("Price...", _price, Validator.validatePrice),
        ]
      ); 
    }

    //BRİEF DESCRİPTİON WİD
    Widget briefDescriptionFieldWid(){
      return Column(
        children: <Widget>[
          createTitleInput("Brief Description"),
          createDescriptionInput(hintText:"Brief Description...", textEditingController: _briefDescription, maxlines:3, validator: Validator.validateBriefDescription),
        ]
      );    
    }

    //DESCRİPTİON WİD
    Widget descriptionFieldWid(){
      return Column(
        children: <Widget>[
          createTitleInput("Description"),
          createDescriptionInput(hintText:"Description...",  textEditingController: _description, maxlines:9, validator: Validator.validateDescription),
        ]
      );
    }  

      
    
    //DESİGNS
    return Column(
      children: <Widget>[
        insctructurFieldWid(),
        maxParticipantFieldWid(),
        priceFieldWid(),
        briefDescriptionFieldWid(),
        descriptionFieldWid(),
      ],
    );
  }
}