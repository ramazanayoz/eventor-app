
import 'package:eventor/denem9-firebaseTum/core/services/eventForm_provider.dart';
import 'package:eventor/denem9-firebaseTum/core/services/validator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class XThirdStep extends StatelessWidget {


  //VAR
  final TextEditingController _country = new TextEditingController();
  final TextEditingController _state = new TextEditingController();
  final TextEditingController _city = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  String _subLocality;
  String _thoroughfare; 
  String _subThoroughfare; 
  String _postalCode;
  
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAdrres;

  bool _status = false;
  XEventFormProv _eventFormProv;
  


  @override
  //DESİGNS
  Widget build(BuildContext context) {

    //VAR
    _eventFormProv =  Provider.of<XEventFormProv>(context);

    //İNİTSTATE FOR NOT LOSİNG DATA IN REFRESHİNG 
    _country.text = _eventFormProv.country;
    _state.text = _eventFormProv.state;
    _city.text = _eventFormProv.city;
    _address.text = _eventFormProv.address;

    //METHODS 
    //textfromfiled deki inputlar her değiştiğinde çalıştırılır 
    refreshProvVariables(){
      print("refreshProvVariables vorking");
      _eventFormProv.country =  _country.text;
      _eventFormProv.state = _state.text;
      _eventFormProv.city = _city.text;
      _eventFormProv.address = _address.text;
      _eventFormProv.sublocality = _subLocality;
      _eventFormProv.thoroughfare = _thoroughfare;
      _eventFormProv.subThoroughfare = _subThoroughfare;
      _eventFormProv.postalCode = _postalCode;
     // _eventFormProv.latitude = _currentPosition.latitude;
      //_eventFormProv.longitude = _currentPosition.longitude;
    }



  //GET ADDRESS FROM LATLng
  _getAddressFromLatLng() async {
      List<Placemark> p = await geolocator.placemarkFromCoordinates( _currentPosition.latitude, _currentPosition.longitude );
      Placemark place = p[0];
      if(place != null){
        Placemark placeMark  = p[0]; 
        _country.text = placeMark.country;
        _state.text = placeMark.administrativeArea;
        _city.text = placeMark.locality;
        _subLocality = placeMark.subLocality;
        _thoroughfare = placeMark.thoroughfare;
        _subThoroughfare = placeMark.subThoroughfare;
        _postalCode = placeMark.postalCode;
        String address =  "${_country.text}, ${_state.text}, ${_city.text}, ${_subLocality}, ${_thoroughfare}, ${_subThoroughfare}, postal code:${_postalCode} " ;
        _address.text = address;
        refreshProvVariables();
       //_currentAdrres = "${country}, ${administrativeArea}, ${locality}, ${subLocality},   ${thoroughfare}, ${subThoroughfare}, ";
        //print("currentt address: ${_currentAdrres} ");

      }
  }

  //GET CURRENT LOC METHOD
  _getCurrentLocation(){
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position){
            if(position != null){
              _currentPosition = position;
              _getAddressFromLatLng();
            }
      }).catchError((e){
        print(e);
      });
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
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _textEditingController,
                validator: validator,
                autovalidate: true,
                onChanged: (val){
                  refreshProvVariables();
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

    //STATE FİELD WİD DESİGN
    Widget countryFieldWid(){
      return Column(    
        children: <Widget>[
          createTitleInput("Country"),
          createTextInput("Country...", _country,  Validator.validateState),
        ]
      );          
    }


    //STATE FİELD WİD DESİGN
    Widget stateFieldWid(){
      return Column(    
        children: <Widget>[
          createTitleInput("State/Province"),
          createTextInput("State...", _state,  Validator.validateState),
        ]
      );          
    }

        //CİTY FİELD WİD DESİGN
    Widget cityFieldWid(){
      return Column(
        children: <Widget>[
          createTitleInput("City"),
          createTextInput("City...", _city, Validator.validateCity ),
        ]
      );    
    }

    //ADDRESS FİELD WİD DESİGN
    Widget addressFieldWid(){
      return Column(
        children: <Widget>[
          createTitleInput("Address"),
          createTextInput("Address...", _address,  Validator.validateAddress),
        ]
      );           
    }  

    Widget getAddressButton(){
      return Row(
        children: <Widget>[
          SizedBox(height: 70.0,),
          Container(
            color: Colors.blue,
            child: FlatButton(
              child: Text(
                "Get address from gps",
                style: TextStyle(color: Colors.white),
              ), 
              onPressed: ()  {
                 _getCurrentLocation();
                 refreshProvVariables();
              },
            )
          )
        ]
      );
    }

    return Column(
      children: <Widget>[
        getAddressButton(),
        countryFieldWid(),
        stateFieldWid(),
        cityFieldWid(),
        addressFieldWid(),
      ],
    );

  }
}