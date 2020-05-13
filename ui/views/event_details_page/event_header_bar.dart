
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/deneme21-ui-event/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XHeaderBar extends StatefulWidget {
  @override
  _XHeaderBarState createState() => _XHeaderBarState();
}

class _XHeaderBarState extends State<XHeaderBar>  with TickerProviderStateMixin  {


  //VAR
  bool isFavorite = false;
  XEvent _event;
  Animation<double> appBarSlide;
  AnimationController bodyScrollAnimationController;
  bool hasTitle = true;

  //init
  void initState() {
    bodyScrollAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _event = Provider.of<XEvent>(context);



    
    return AnimatedBuilder(
      animation: appBarSlide, 
      builder: (context, snapshot) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: InkWell(
                    onTap: (){
                      if (bodyScrollAnimationController.isCompleted) bodyScrollAnimationController.reverse();
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: hasTitle ? Colors.white: Colors.black,
                      ),
                    ),
                  ),
                  color: hasTitle ? Theme.of(context).primaryColor : Colors.white,
                ),
                if(hasTitle) Text(_event.title, style: titleStyle.copyWith(color: Colors.white)),
                Card(
                  shape: CircleBorder(),
                  elevation: 0,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () => setState(() => isFavorite = !isFavorite),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(isFavorite ? Icons.favorite: Icons.favorite_border, color: Colors.white),
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ), 
          ),
        );
      });
  
  
  }
}