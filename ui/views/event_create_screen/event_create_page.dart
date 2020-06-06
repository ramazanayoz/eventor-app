import 'dart:io';

import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:eventor/denem9-firebaseTum/core/models/state.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/firebase_methods.dart';
import 'package:eventor/denem9-firebaseTum/core/services/eventForm_provider.dart';
import 'package:eventor/denem9-firebaseTum/core/services/state_widget.dart';
import 'package:eventor/denem9-firebaseTum/core/services/validator.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_create_screen/firstStep.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_create_screen/secondStep.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_create_screen/thirdStep.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class XEventCreatePage extends StatefulWidget {
  @override
  _XEventCreatePageState createState() => _XEventCreatePageState();
}

class _XEventCreatePageState extends State<XEventCreatePage> with AutomaticKeepAliveClientMixin {
  
  //VAR
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  bool _autoValidate = false;

  int _currentStep = 0;
  bool _complete = false;
  XEventFormProv _eventFormProv;
 
  bool _isAutoValidateS1 = false;
  bool _isAutoValidateS2 = false;
  bool _isAutoValidateS3 = false;

  String imageUrl;
  String imageLocation;
  XFirebaseMethod _authModel = XFirebaseMethod();

  bool _load = false;

  StepperType _stepperType = StepperType.horizontal;

  List<Step> _stepslist ;
  //------------------------------
  StepState _step1State = StepState.editing;
  StepState _step2State = StepState.editing;
  StepState _step3State = StepState.editing;
  

  next(){
    print("next yapılan şuanki current step ${_currentStep} lengthi ${_stepslist.length}");
    _currentStep + 1 != _stepslist.length
      ? goTo(_currentStep +1) : submit() ;
  }

  cancel(){
    if(_currentStep > 0){
        goTo(_currentStep -1 );
    }
  }

  goTo(int step) {
    print("goto da olan step ${step}");
    setState( () => _currentStep = step );
  }


  submit(){
    saveToDB().then((val){
      _eventFormProv.reset();
    });
  }

  bool isInputsAvailable(int step){
    if(step == 0){
      try{
        print("step0 input working");
        setState(()=>_step1State = StepState.error); 
        setState(() => _isAutoValidateS1 = true );
        if(Validator.validateEventName(_eventFormProv.title.trim()) != null) {return false;}
        print("category....... ${_eventFormProv.category}");
        if(_eventFormProv.category ==  null || _eventFormProv.category == "[]" ) {return false;}
        setState(()=>_step1State = StepState.complete);
        setState(() => _isAutoValidateS1 = false );

        return true;
      }catch(e){ return false;}
    }
    if(step ==1){
      try{
        print("step1 input working");
        setState(()=>_step2State = StepState.error);
        setState(() => _isAutoValidateS2 = true );
        if(Validator.validateMaxParticipant(_eventFormProv.maxParticipant.trim()) !=null) {return false;}
        if(Validator.validatePrice(_eventFormProv.price.trim()) !=null) {return false;}
        if(Validator.validateBriefDescription(_eventFormProv.briefDescription.trim()) !=null) {return false;}
        if(Validator.validateDescription(_eventFormProv.description.trim()) !=null) {return false;}
        setState(()=>_step2State = StepState.complete);
        setState(() => _isAutoValidateS2 = false );
        return true;
      }catch(e){return false;}
    }
    if(step==2){
      try{
        print("step2 input working");
        setState(() => _isAutoValidateS3 = true );
        setState(()=>_step3State = StepState.error);
        if(Validator.validateCity(_eventFormProv.city.trim()) !=null) {return false;}
        if(Validator.validateState(_eventFormProv.state.trim()) !=null) {return false;}
        if(Validator.validateAddress(_eventFormProv.address.trim()) !=null) {return false;}
        setState(()=>_step3State = StepState.complete);
        setState(() => _isAutoValidateS3 = false );
        return true;
      }catch(e){return false;}
    }
  }

  //SAVE TO DB METHOD
  Future<void> saveToDB() async {
    print("saveTodb");
    try{
      //picture save to db and get link
      File _image = _eventFormProv.imageFile;
      if(_image != null){
        imageLocation =  await _authModel.uploadImage(_image, _eventFormProv.title);
        imageUrl =  await _authModel.getImageUrl(imageLocation,);
      }
      //Event save to db
      XStateModel appState = await XStateWidget.of(context).state; 
      await _authModel.addEventDatabase(new XEvent( 
          userId: appState.user.userId,  
          imageLocation: imageLocation,
          imageUrl: imageUrl,
          title: _eventFormProv.title,
          category: _eventFormProv.category,
          startDate: _eventFormProv.startDate,
          endDate: _eventFormProv.endDate,
          price: _eventFormProv.price, 
          instructur : _eventFormProv.instructur, 
          maxParticipant : _eventFormProv.maxParticipant, 
          briefDescription : _eventFormProv.briefDescription, 
          description: _eventFormProv.description,
          
      ));
      //Location save to db
      await _authModel.addLocationDatabase(new XLocation( 
        country: _eventFormProv.country,
        state: _eventFormProv.state,
        city: _eventFormProv.city,
        sublocality: _eventFormProv.sublocality,
        thoroughfare: _eventFormProv.thoroughfare,
        subThoroughfare: _eventFormProv.subThoroughfare,
        postalCode: _eventFormProv.postalCode,
        address: _eventFormProv.address
      ));
      Navigator.of(context).pop();  
    }catch(e){
        print("Create Event Error: $e");
    }
  }


  //-----------------------------------


  @override 
  Widget build(BuildContext context) {
    super.build(context);
  
    //VAR
    _eventFormProv =  Provider.of<XEventFormProv>(context); 

    _stepslist = [
        Step(
          title: const Text('Create Event'),
          isActive: _currentStep == 0 ? true : false,
          state: _step1State,
          content: XFirstStep(isAutoValidate:_isAutoValidateS1),
        ),
        Step(
          title: const Text('Description'),
          isActive: _currentStep == 1 ? true : false,
          state: _step2State,
          content: Column(  ///-----------
            children: <Widget>[
              XSecondStep(isAutoValidate:_isAutoValidateS2),
            ],
          ),
        ),
        Step(
          title: const Text('Location'),
          subtitle: const Text('Last'),
          isActive: _currentStep == 2 ? true : false,
          state: _step3State,
          content: Column(   ///-----------
            children: <Widget>[
              XThirdStep(isAutoValidate:_isAutoValidateS3), 
            ],
          )
        )
    ];

    Widget loadingIndicator = new Container(
        color: Colors.blueAccent,
        width: 70.0,
        height: 70.0,
        child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
      );
    
  //---------DESİGNS

  //BACK BUTTON DESİGN METHOD
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

    return new Scaffold(
      body: new Container(
      color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    headerBackButtonWid(),
                  ],
                ),
              ),
            Expanded(
              child: _load == false ? 
               Container(
                color: Color(0xffFFFFFF),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Stepper(
                        steps: _stepslist,
                        type: _stepperType,
                        currentStep: _currentStep,
                        onStepContinue: next,
                        onStepCancel: cancel,
                        onStepTapped: (step) => goTo(step),
                        controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 70.0,),
                              Container(
                                color: Colors.purple,
                                child: FlatButton(
                                  shape: StadiumBorder(),
                                  child: Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: ()  {
                                    switch(_currentStep){
                                      case 0:{
                                        isInputsAvailable(0) == true ? next() : print("1.step inputs hatalı");
                                      }
                                      break;
                                      
                                      case 1:{
                                       isInputsAvailable(1) == true ? next() : print("2.step inputs hatalı");
                                      }
                                      break;
                                      
                                      case 2:{
                                        //stepler hepsi tekrar kontrol edilir
                                        if(isInputsAvailable(0) == true){
                                          if(isInputsAvailable(1) == true){
                                            if(isInputsAvailable(2) == true){
                                                setState(() => _load = true);
                                                next();
                                            }
                                          }else{setState( () =>_currentStep = 1 );}
                                        }else{setState( () =>_currentStep = 0 );}
                                      }
                                      break;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 50,),
                              Container(
                                color: Colors.purple,
                                child: FlatButton(
                                  shape: StadiumBorder(),
                                  child: Text(
                                    "Back",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: cancel,
                                ),
                              ),                              
                            ],
                          );
                        },
                    ),
                  )
                )
              ): new Align(child: loadingIndicator, alignment: FractionalOffset.center,),
            )
            //-- !_status ? _getActionButtons() :  _getActionButtons(),
          ],
        ),
      )
    );
    //-------------



  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}