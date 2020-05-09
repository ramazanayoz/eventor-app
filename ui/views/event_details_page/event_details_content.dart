import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/deneme17-event-ui/model/guest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../styleguide.dart';


class XEventDetailsContent extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    
    //VAR
    final _event = Provider.of<XEvent>(context);
    final _screenWidth = MediaQuery.of(context).size.width;

    //DESİGNS
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            height: 100,
          ),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth * 0.2),
            child: Text(
              _event.title,
              style: eventWhiteTitleTextStyle,
            ),
          ),
          new SizedBox(height: 10,),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth * 0.24),
            child: FittedBox(
              child: Row(
                children: <Widget>[
                  new Text(
                    "-", 
                    style: eventLocationTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )
                  ),
                  new Icon(Icons.location_on, color: Colors.white, size: 15),
                  new SizedBox(width: 5,),
                  new Text(
                    _event.title,
                    style: eventLocationTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          ),
          new SizedBox(
            height: 10,
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text("GUESTS", style: guestTextStyle,),
          ),
          new SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for(final _guest in guestlist) Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: Image.asset(
                        _guest.imagePath,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            )
          ),
          new Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: _event.title, style: punchLine1TextStyle),
                  TextSpan(text: _event.title, style: punchLine2TextStyle),
                ]
              ),
            ),
          ),
          if(_event.description.isNotEmpty) new Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_event.description, style: eventLocationTextStyle,),
          ),
          /*
          if (_event.galleryImagesList.isNotEmpty) new Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
            child: Text(
              "GALLERY",
              style: guestTextStyle,
            ),
          ),
          new SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for(final _galleryImagePath in _event.galleryImagesList)
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.asset(
                        _galleryImagePath,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
          )
          */
        ],
      )
    );
  }
}