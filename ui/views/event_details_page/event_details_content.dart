import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/deneme17-event-ui/model/guest.dart';
import 'package:eventor/deneme21-ui-event/constant/color.dart';
import 'package:eventor/deneme21-ui-event/constant/text_style.dart';
import 'package:eventor/deneme21-ui-event/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../styleguide.dart';


class XEventDetailsContent extends StatelessWidget {
  
  XEvent _event;
  DateTime  _eventStartDate; 
  DateTime _eventdEndDate ;
  bool _isReadMActive = false;
  String _firstCharOrganizator = "";
  int _differenceDay;
  int _differenceHour;
  

  @override
  Widget build(BuildContext context) {
    
    //VAR
    final _event = Provider.of<XEvent>(context);
    final _screenWidth = MediaQuery.of(context).size.width;
    double headerImageSize = 0;

    final DateFormat _dateFormat = DateFormat('HH:mm');

    //string to DateTime
    try{ _eventStartDate = DateFormat('yyyy-MM-dd HH:mm').parse(_event.startDate); }catch(e){ print(e); };  
    try{ _eventdEndDate = DateFormat('yyyy-MM-dd HH:mm').parse(_event.endDate); }catch(e){ print(e); }; 

    try{ _differenceDay = _eventStartDate.difference(_eventdEndDate).inDays;} catch(er){_differenceDay = 0;};
    try{ _differenceHour = _differenceDay %24  ; }catch(er){_differenceHour = 0;};


    //get first char organizator
    try{ _firstCharOrganizator = _event.instructur[0]; }catch(er){ _firstCharOrganizator = "";};
    
    Widget buildHeaderImage(){
      headerImageSize = MediaQuery.of(context).size.height / 2.5;
      return Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: headerImageSize,
            child: Hero(
              tag:_event.title,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Image.network(
                  _event.imageUrl,
                  fit:BoxFit.cover,
                ),
              ),
            )
          ),
         // buildHeaderButton(),
        ],
      );
    }


    Widget buildEventTitle(){
      return Container(
        child: Text(
          _event.title,
          style: headerStyle.copyWith(fontSize: 32),
        ),
      );
    }

  
    Widget buildEventDate(){
      return Container(
        child: Row(
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("${DateTimeUtils.getMounth(_eventStartDate)}", style: monthStyle,), 
                  Text("${DateTimeUtils.getDayOfMounth(_eventStartDate)}", style: titleStyle,), 
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(DateTimeUtils.getDayOfWeek(_eventStartDate), style: titleStyle), 
                SizedBox(height: 4),
                Text("Starting time: ${_dateFormat.format(_eventStartDate)} ", style: subtitleStyle,),
                Text("Long: ${_differenceDay} day, ${_differenceHour} hour   ", style: subtitleStyle,),
              ],
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: ShapeDecoration(shape: StadiumBorder(), color: primaryLight),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 8,),
                  Text("Add To Calandar", style: subtitleStyle.copyWith(color: Theme.of(context).primaryColor)),
                  FloatingActionButton(
                    mini: true,
                    onPressed: (){},
                    child: Icon(Icons.add),
                  )
                ],
              ),
            )  
          ],
        ),
      );
    }



    Widget buildAboutEvent() {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("About", style: headerStyle,),
              SizedBox(height: 0,),
              Text(
                _isReadMActive ? _event.description  //read more active değilse ilk 5 karakretri alır
                  :  _event.description.substring(0, 55 ), 
                style: subtitleStyle,
              ),
              SizedBox(height: 8,),
              InkWell(
                child: Text(
                  _isReadMActive ? "": "Read more..."   ,
                  style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
                ),
                onTap: (){
                  setState(() => _isReadMActive = true );
                },
              )
            ],
          );
        }
      );
    }

    buildOrganizeInfo(){
      return Row(
        children: <Widget>[
          CircleAvatar(
            child: Text(_firstCharOrganizator),
          ),
          SizedBox(height: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_event.instructur, style:titleStyle),
              SizedBox(height: 4,),
              Text("Instructor", style: subtitleStyle),
            ],
          ),
          Spacer(),
          FlatButton(
            child: Text("Follow", style: TextStyle(color: Theme.of(context).primaryColor),),
            onPressed: (){},
            shape: StadiumBorder(),
            color:primaryLight,
          )
        ],
      );
    }

    //DESİGNS
    return  SingleChildScrollView(
      //controller: controller
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildHeaderImage(),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildEventTitle(),
                SizedBox(height: 16,),
                buildEventDate(),
                SizedBox(height: 24,),
                buildAboutEvent(),
                SizedBox(height: 24,),
                buildOrganizeInfo(),
                SizedBox(height: 24,),
                //buildEventLocation(),
                SizedBox(height: 124,),
              ],
            ),
          )
        ],
      )
    );





    
    
    
  }






}