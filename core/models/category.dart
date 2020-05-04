import 'package:flutter/material.dart'
;
class XCategory {
  
  final int id;
  final String name;
  final IconData icon;

  //constructur
  XCategory({this.id, this.name, this.icon});

  //methods
    static List<XCategory> getCategories(){
    return <XCategory>[
      XCategory(id: 0, name: 'Music'),
      XCategory(id: 1, name: 'Meetup'),
      XCategory(id: 2, name: 'Golf'),
      XCategory(id: 3, name: 'Birthday'),
    ];
  }

  //LİST TO ANOTHER METHOD
  static List<Map<String, String>> getCatAsStringList(){
   return getCategories().map((c) => {"display": c.name, "value": c.name} ).toList();
  }

}

  //methods  
final allCategory = XCategory(
  id: 0,
  name: "All",
  icon: Icons.search,
);

final musicCategory = XCategory(
  id: 1,
  name: "Music",
  icon: Icons.music_note,
);

final meetUpCategory = XCategory(
  id: 2,
  name: "Meetup",
  icon: Icons.location_on,
);

final golfCategory = XCategory(
  id: 3,
  name: "Golf",
  icon: Icons.golf_course, 
);


final birthdayCategory = XCategory(
  id: 4, 
  name: "Birthday",
  icon: Icons.cake,
);

final listcategories = [
  allCategory,
  musicCategory,
  meetUpCategory,
  golfCategory,
  birthdayCategory,
];



  


