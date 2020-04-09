class XCategory {
  
  int id;
  String name;

  //constructur
  XCategory(this.id, this.name);

  //methods
  static List<XCategory> getCategories(){
    return <XCategory>[
      XCategory(1, 'Sport'),
      XCategory(2, 'Technology'),
      XCategory(3, 'Programming'),
      XCategory(4, 'Work Shops'),
      XCategory(5, 'OutDoor'),
      XCategory(6, 'Entertainment'),
      XCategory(7, 'Healty')
    ];
  }


}