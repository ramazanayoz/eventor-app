class Validator {
  static String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  static String validatePassword(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }

  static String validateName(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a name.';
    else
      return null;
  }

  static String validateNumber(String value) {
    Pattern pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a number.';
    else
      return null;
  }

  //for createEvent page validate

  static String validateEventName(String value){
    int valueLength = value.length;
    if(valueLength<2){
      return "Please enter an event name";
    }
  }  

  static String validatePrice(String value){
    Pattern pattern = r"^[0-9]*$"; //1..999 https://www.regular-expressions.info/numericranges.html
    RegExp regex = RegExp(pattern);
    int valueLength =value.length;
    print("asdasd ${valueLength} ");
    if(!regex.hasMatch(value) || valueLength > 10)
      return "Please enter a valid number.";
  }  

  static String validateCity(String value){
    int valueLength = value.length;
    if(valueLength<2){
      return "Please enter a city";
    }
  }

  static String validateState(String value){
    int valueLength = value.length;
    if(valueLength<2){
      return "Please enter a state";
    }
  }  

  static String validateAddress(String value){
    int valueLength = value.length;
    if(valueLength<2){
      return "Please enter a address";
    }
  }

  static String validateMaxParticipant(String value){
    Pattern pattern = r"^[0-9]*[1-9][0-9]*$"; //1..999 https://www.regular-expressions.info/numericranges.html
    RegExp regex = RegExp(pattern);
    int valueLength =value.length;
    print("asdasd ${valueLength} ");
    if(!regex.hasMatch(value) || valueLength > 10)
      return "Please enter a valid number.";
  }

  static String validateBriefDescription(String value){
    int valueLength = value.length;
    if(valueLength<2){
      return "Please enter a brief";
    }
  }

  static String validateDescription(String value){
    int valueLength = value.length;
    if(valueLength<2){
      return "Please enter a description";
    }
  }      


}
