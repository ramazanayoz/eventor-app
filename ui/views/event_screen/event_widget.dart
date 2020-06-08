
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:eventor/denem9-firebaseTum/ui/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class XEventWidget extends StatelessWidget {

  //VAR
  final XEvent xevent;
  final XLocation xlocation;
  //CONSTRUCTUR
  const XEventWidget({Key key, this.xevent, this.xlocation}) : super(key: key);
  
  //FUNCT
  changeDateFormat(String _date){
    DateTime _dateTime =DateFormat('yyyy-MM-dd HH:mm').parse(_date);
    _date = DateFormat('dd.MM.yyyy').format(_dateTime);
    return(_date);
  }



  @override
  Widget build(BuildContext context) {
    print("renderend event widget");
    print("${xevent.title} event showing on listView ");
    print("xxlocation: ${xlocation?.city}");
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Column(
              children: <Widget>[
                new ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.purple,
                    width: 140,
                    height: 180,
                    child: Hero(
                      tag: xevent.imageUrl,
                      child:  xevent.imageUrl == null 
                        ? Image.asset(
                            "assets/event_images/cooking_1.jpeg", 
                            height: 150, 
                            width: 50, 
                            fit: BoxFit.cover,
                          ) 
                        : Image.network(
                            xevent.imageUrl, 
                            height: 150, 
                            width: 50, 
                            fit: BoxFit.cover,
                          ),
                        ),
                  ),
                ),
              ],
            ),
            buildEventInfo()
          ],
        ),
      ),
    );
  }

  Widget buildEventInfo(){
    return Flexible(
    child:Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${xevent.title.trim()}",
            overflow: TextOverflow.fade,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 10,),
          Text(
            "${changeDateFormat(xevent?.startDate ?? "")} - ${xlocation?.state ?? ""}, ${xlocation?.city ?? ""}", 
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey
            )
          ),
          SizedBox(height:10),
          //Mesurement and attendees part
          Container(
            child: Row(
              children: [
                //measurements row part
                Row(
                  children:[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.circle
                      ),
                      child:Icon(
                        Icons.navigation,
                        size: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "23 km",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )
                    ),
                  ]
                ),
                SizedBox(width: 10,),
                //attendess Part
                Row(
                  children:[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.circle
                      ),
                      child:Icon(
                        Icons.people,
                        size: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "23 attendees",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )
                    ),
                  ]
                ),
              ],
            )
          ),
          SizedBox(height:12),
          //Price Row Part
          Row(
            children:[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                    style: BorderStyle.solid,
                  ),
                  shape: BoxShape.circle
                ),
                child:Icon(
                  Icons.attach_money,
                  size: 18,
                ),
              ),
              SizedBox(width: 5),
              Text(
                "${xevent.price}\$ ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                )
              ),
            ]
          ),
          SizedBox(height: 40,),
          
          //Organizator row
          Row(
            children:[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                    style: BorderStyle.solid,
                  ),
                  shape: BoxShape.circle
                ),
                child:Icon(
                  Icons.account_circle,
                  size: 14,
                ),
              ),
              SizedBox(width: 5),
              Text(
                "${xevent.instructur}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                )
              ),
            ]
          ),
        ],
      ),
    )
    );
  }

}