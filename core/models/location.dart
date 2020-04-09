
class XLocation {

  //VAR
  String city;
  String state;
  String address;
  String eventId;

  //CONST
  XLocation({
    this.city,
    this.state,
    this.address,
    this.eventId,
  });
 

  Map<String, dynamic> classObjConvertToJson() =>{
    "eventId" : eventId,
    "city" : city,
    "state" : state,
    "address" : address,
  };

}