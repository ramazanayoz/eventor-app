import 'package:eventor/denem9-firebaseTum/ui/views/event_details_page/event_details_page.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_screen/category_widget.dart';
import 'package:eventor/denem9-firebaseTum/ui/views/event_screen/event_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/denem9-firebaseTum/core/models/category.dart';
import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:eventor/denem9-firebaseTum/core/services/app_state.dart';
import 'package:eventor/denem9-firebaseTum/ui/styleguide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event_page_background.dart';

class XEventScreen extends StatelessWidget {

  //DESİGNS  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body : ChangeNotifierProvider<XAppState>(
        create: (_) => XAppState(),
        child: Stack(
          children: <Widget>[
            XEventPageBackground(screenHeight: MediaQuery.of(context).size.height),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        children: <Widget>[
                          new Text(
                            'EVENTS',
                            style: fadedTextStyle,
                          ),
                          new Spacer(),
                          new Icon(
                            Icons.person_outline,
                            color: Color(0x99FFFFFF),
                            size: 30,
                          )
                        ],
                      )
                    ),
                    new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text("What's Up", style: whiteHeadingTextStyle),
                    ),
                    new Padding(
                      padding: const EdgeInsets.symmetric(vertical:  24.0),
                      child: Consumer<XAppState>( //category değişiminde notif edilince bu kısım yeniden renderlenir
                        builder: (context, xappState, widget) => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for(final _category in listcategories)
                                XCategoryWidget(category: _category)     
                                //kategoriler tek tek children içine oluşturulur
                            ],
                          ),
                        )
                      ),
                    ),
                    new Padding( 
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Consumer<XAppState>(
                          builder: (context, xappState ,widget) => StreamBuilder(
                              stream: Firestore.instance.collection("events").snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                List<XEvent> listevents= [];
                                if(snapshot.hasData){
                                  listevents = snapshot.data.documents
                                    .map((doc) => XEvent.mapJsonConvertToClassObj(doc.data)).toList();
                                    print("${xappState.selectedCategoryName}");
                                }
                                  return Column(
                                    children: <Widget>[
                                     
                                        for(final _event in listevents.where( (e) =>
                                          xappState.selectedCategoryName.contains("All") ?  true
                                          : e.category.contains(xappState.selectedCategoryName) ) )
                                            GestureDetector(     //for ile tekrar tekrar oluşturulur
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => XEventDetailsPage(xevent: _event),
                                                  )
                                                ); 
                                              }, 
                                              child: XEventWidget(xevent: _event),  
                                            ),
                                      
                                    ],
                                  );  

                              },
                          )
                        )

                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}