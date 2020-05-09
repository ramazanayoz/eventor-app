
class XLocation {

  //VAR
  String country;
  String state;
  String city;
  String sublocality;
  String thoroughfare;
  String subThoroughfare;
  String postalCode;
  String address;
  String eventId;

  //CONST
  XLocation({
    this.country,
    this.state,
    this.city,
    this.sublocality,
    this.thoroughfare,
    this.subThoroughfare,
    this.postalCode,
    this.address,
    this.eventId,
  });
 

  Map<String, dynamic> classObjConvertToJson() =>{
    "eventId" : eventId,
    "country" : country,
    "state" : state,
    "city" : city,
    "sublocality" : sublocality,
    "thoroughfare" : thoroughfare,
    "subThoroughfare" : subThoroughfare,
    "postalCode" : postalCode,
    "address" : address,
  };

}