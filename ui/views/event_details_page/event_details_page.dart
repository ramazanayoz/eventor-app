import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_details_page/event_detail_background.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_details_page/event_details_content.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_details_page/event_header_bar.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_details_page/event_price_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XEventDetailsPage extends StatelessWidget {
  //VAR
  final XEvent xevent;
  //CONSTRUCTUR
  const XEventDetailsPage({Key key, this.xevent}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<XEvent>.value(
        //önemmmli farklı bir yapı value ile kullanımı  ile xevente herkes ulaşabiliyor
        value: xevent,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[ 
            XEventDetailsContent(),
            XPriceBottomBar(),
            XHeaderBar(),
          ]
        ),
      )
    );
  }
} 

            //XEventDetailsBackground(),
            //XEventDetailsContent(),