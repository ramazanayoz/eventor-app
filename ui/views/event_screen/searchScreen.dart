
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/models/location.dart';
import 'package:eventor/denem9-firebaseTum/core/resources/firebase_methods.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_details_page/event_details_page.dart';
import 'package:eventor/deneme21-ui-event/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';


class XSearchSreen extends StatefulWidget { 
  @override
  _XSearchSreenState createState() => _XSearchSreenState();
}

class _XSearchSreenState extends State<XSearchSreen> {

  //VAR
  TextEditingController  _searchController = TextEditingController();
  XFirebaseMethod _firebaseMethod = XFirebaseMethod();
  List<XEvent> _allEventList= [];
  String _word = "fin";
  List<XEvent> _suggestionEventList = [];
  List<XLocation> _findingLocationList = [];
  List<XLocation> _allLocationList = [];

  //FUNCT
  @override
  void initState(){
    super.initState();

    _firebaseMethod.getCurrentFirebaseUser().then((user){
      //initiliazing user list
      _firebaseMethod.fetchAllEvents(user).then((List<XEvent> eventList){ 
        setState(() {
         // print("lisst${eventList[0].title}");
          _allEventList = eventList;
        });
      });
      //initiliazing location list
      _firebaseMethod.fetchAllLocation(user).then((List<XLocation> locationList) {
        setState(() { 
          _allLocationList = locationList;
          print("lisste: ${_allLocationList}"); 
        });
      }); 
    });
  }

  changeDateFormat(String _date){
    DateTime _dateTime =DateFormat('yyyy-MM-dd HH:mm').parse(_date);
    _date = DateFormat('MM dd, yyyy').format(_dateTime);
    return(_date);
  }

  search(String word) {
    _suggestionEventList = [];
    _findingLocationList = [];
    final List<XEvent> suggestionList =  word.isEmpty ? []
      : _allEventList != null
        ?_allEventList.where((XEvent xevent){
          String _word = word.toLowerCase();
          String _getEventTitle = xevent.title.toLowerCase();
          String _getEventDesc = xevent.description.toLowerCase();
          bool matchesEventTitle = _getEventTitle.contains(_word);
          bool matchesEventDesc = _getEventDesc.contains(_word);
          if(matchesEventDesc || matchesEventTitle){
            for(var i = 0 ; i< _allLocationList.length; i++ ){
              if(_allLocationList[i].eventId == xevent.eventId){
                _findingLocationList.add(_allLocationList[i]);
                print("dada: ${_allLocationList[i]}");
              }
            }
          }
          return (matchesEventDesc || matchesEventTitle); 
        }).toList() : [];
        //print("suggestionList: ${suggestionList[0].title}");
        _suggestionEventList = suggestionList;
  }


  //DESİGNS
  @override
  Widget build(BuildContext context) {
    
    //MAİN DESİGN
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchAppBar(context),
      body: SingleChildScrollView(
        child:Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: createEventList(_word),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
            color: Colors.white,
          ),
        )
      )
    );
  }


  Widget searchAppBar(BuildContext context){
    return GradientAppBar(
      backgroundColorStart: Colors.purple[300],
      backgroundColorEnd: Colors.purple,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white), 
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight+20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (val){
              setState(() {
                _word= val;
                search(_word);
              });
            },
            cursorColor: Color(0xff19191b),
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize:35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: (){
                  _searchController.clear();
                  WidgetsBinding.instance.addPostFrameCallback( (_) => _searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:35,
                color: Color(0x88ffffff),
              )
            ),
          ),
        ),
      )
    ); 
  }


  Widget createEventList(String word){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _suggestionEventList.length,
          itemBuilder: (context, index) {
            var event;
            var location;
            if(_suggestionEventList != null){
               event = _suggestionEventList[index];
            }
            if(_findingLocationList != null){
                location = _findingLocationList[index];
            }
           // print("location ${location}");
            return eventCart(event, location);
          }
        )
      ],
    );
  }
  
  Container eventCart(XEvent event, XLocation location){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap:  ()=> Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => XEventDetailsPage(xevent: event),
          )
        ),
        child: Row(
          children: [
            new ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.purple,
                width: 80,
                height: 100,
                child: Hero(
                  tag: event.imageUrl,
                  child: Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            new Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title.trim(), 
                    style:TextStyle(
                      color: Colors.purple, 
                      fontSize: 16, 
                      fontWeight: 
                      FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 4,),
                  event == null ? Container() : Text(changeDateFormat(event.startDate)),
                  SizedBox(height: 4,),
                  location == null ? Container(): Text("${location.state.trim()} ${location.city.trim()} ${location.sublocality.trim()} "),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }





}



