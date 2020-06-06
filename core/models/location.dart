
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

  static XLocation mapConvertClass(Map<String, dynamic> mapData) => XLocation(
    country: mapData["country"],
    state: mapData["state"],
    city: mapData["city"],
    sublocality: mapData["sublocality"],
    thoroughfare: mapData["thoroughfare"],
    subThoroughfare: mapData["subThoroughfare"],
    postalCode: mapData["postalCode"],
    address: mapData["address"],
    eventId: mapData["eventId"],
  );

}