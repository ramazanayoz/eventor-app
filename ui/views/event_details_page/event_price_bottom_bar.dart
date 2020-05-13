import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/deneme21-ui-event/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class XPriceBottomBar extends StatelessWidget {
  
  XEvent _event ;
  
  @override
  Widget build(BuildContext context) {
       
    final _event = Provider.of<XEvent>(context);

   Widget buildPriceBar(){
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Price", style: subtitleStyle,),
              SizedBox(height: 8,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "\$${_event.price}", style: titleStyle.copyWith(color: Theme.of(context).primaryColor)),
                    TextSpan(text: "/per person", style: TextStyle(color: Colors.black)),
                  ]
                ),
              ),
            ],
          ),
          Spacer(),
          RaisedButton(
            onPressed: (){},
            shape: StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Theme.of(context).primaryColor,
            child: Text(
              "Get a Ticket",
              style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            )
          )
        ],
      ),
    );
   }


    return Align(
      alignment: Alignment.bottomCenter,
      child:buildPriceBar(),
    );
  
  
  
  }

  
}