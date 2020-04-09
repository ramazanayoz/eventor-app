import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




  //FUNCT
Future<TimeOfDay> _selectTime(BuildContext context){
    final now = DateTime.now();
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute:now.minute),
    );
}



Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
    context: context, 
    initialDate: DateTime.now().add(Duration(seconds: 1)), 
    firstDate: DateTime.now(), 
    lastDate: DateTime(2100),
);


Dialog showDateTimeDialog( BuildContext context, {
  @required ValueChanged<DateTime> onSelectedDate, // BU çağırılan yeri yani data_time picker widget2 deki değeri değiştirir
  DateTime initialDate,})
  {
    final dialog = Dialog(
        child: XDateTimeDialog(onSelectedDate: onSelectedDate, initialDate: initialDate),       
    );
  
    showDialog(
        context: context, 
        builder: (BuildContext context) {
          print("showDialog working");
          print("onSelectedDate: ${onSelectedDate}  initialDate: ${initialDate} ");
          return dialog;
        }
    );
}

 
class XDateTimeDialog extends StatefulWidget {
  //VAR
  final ValueChanged<DateTime> onSelectedDate;
  final DateTime initialDate;

  
  //CONST
  const XDateTimeDialog({
    @required this.onSelectedDate,
    @required this.initialDate,
    Key key,
  }) : super(key: key);


  @override
  _XDateTimeDialogState createState() => _XDateTimeDialogState();
}

class _XDateTimeDialogState extends State<XDateTimeDialog> {
  
  //VAR
  DateTime _selectedDate ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = widget.initialDate;
  }

  //DESİGN
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            'Select time',
            style: Theme.of(context).textTheme.title,
          ),
          const SizedBox(height: 16,),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                onPressed: () async {
                  final date = await _selectDateTime(context);
                  print("yeni seçilen date: ${date}");
                  if (date == null) return;
                  // ay yıl gün için seçilen yeni değerler atanır
                  setState(() {
                    _selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      _selectedDate.hour,
                      _selectedDate.minute,
                    );
                  });
                  print("new selectedDate only date: ${_selectedDate}");
                  widget.onSelectedDate(_selectedDate); // BU data_time picker widget2 deki değeri değiştirir
                },
              ),
              const SizedBox(width: 8,),
              RaisedButton(
                child: Text(DateFormat('HH:mm').format(_selectedDate)),
                onPressed: () async {
                  final time = await _selectTime(context);
                  print("yeni seçiyen time: ${time}");
                  if (time == null) return;

                  setState(() {
                    // yeni seçilen saat dakika gün için  yeni değerler atanır
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      time.hour,
                      time.minute,
                    );
                  });
                  print("new selectedDate only time: ${_selectedDate}");

                  widget.onSelectedDate(_selectedDate); // BU data_time picker widget2 deki değeri değiştirir
                },
              )
            ],
          ),
          new OutlineButton(
            child: Text('Schedule!'),
            onPressed: (){
              Navigator.of(context).pop();
            },
            highlightColor: Colors.orange,
          )
        ],
      ),
    );
  }
}






