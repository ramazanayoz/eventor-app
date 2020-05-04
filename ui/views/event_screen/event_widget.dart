
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/ui/styleguide.dart';
import 'package:flutter/material.dart';



class XEventWidget extends StatelessWidget {

  //VAR
  final XEvent xevent;
  //CONSTRUCTUR
  const XEventWidget({Key key, this.xevent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30)),

              child:  xevent.imageUrl == null 
                ? Image.asset("assets/event_images/cooking_1.jpeg", height: 150, fit: BoxFit.fitWidth,) 
                : Image.network(xevent.imageUrl, height: 150, fit: BoxFit.fitWidth,),),
            new Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          xevent.name,
                          style: eventTitleTextStyle,
                        ),
                        SizedBox(height: 10,),
                        FittedBox(
                          child: Row(
                            children: <Widget>[
                              new Icon(Icons.location_on),
                              new SizedBox(width: 5,),
                              new Text(xevent.name, style: eventLocationTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      xevent.startDate.toUpperCase(),
                      textAlign: TextAlign.right,
                      style: eventLocationTextStyle.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        )
      ),
    );
  }
}