import 'package:flutter/material.dart';
import 'api/notification_api.dart';
import 'calendar.dart';

void main() {
  runApp(const MyApp());
}

class Exam{
  late String subject;
  late DateTime dateTime;

  Exam(this.subject, this.dateTime);

  @override
  String toString() {
    String convertedDateTime = "${dateTime.day.toString().padLeft(2,'0')}/${dateTime.month.toString().padLeft(2,'0')}/${dateTime.year.toString()}  ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
    return subject + " " + convertedDateTime;
  }

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePageWrapper(),
    );
  }
}
class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({Key? key}) : super(key: key);

  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<HomePageWrapper> {
  MyHomePage({Key? key});

  @override
  void initState(){
    super.initState();
    NotificationApi.init();

  }

  final String title = "Exams Schedule";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final List<Exam> elements = [
   Exam('Data Science', DateTime.now().add(const Duration(days: 1, hours: 2))),
   Exam('Artificial Intelligence', DateTime.now().add(const Duration(minutes: 6))),
   Exam('Web development', DateTime.now().subtract(const Duration(hours: 2)))];

  TextEditingController subjectController = TextEditingController();

  void addSubject() {
    setState(() {
      DateTime _dateTime = DateTime(selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute);

      elements.add(Exam( subjectController.text, _dateTime));
      subjectController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.add, color: Colors.white,),
          onPressed: () => {
            addSubject()
          },
          tooltip: 'Schedule exam',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Event calendar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarPageWrapper(elements: this.elements)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
                children: [
                  TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Subject Name',
                  ),
                ),
                 Container(
                   margin: const EdgeInsets.only(top: 7.0),
                   child: ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: const Text("Choose Date"),
                  )),
                  Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                  Container(
                    margin: const EdgeInsets.only(top: 7.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: const Text("Choose Time"),
                    ),
                  ),
                  Text("${selectedTime.hour}:${selectedTime.minute}"),

                ]
            ),
          ),

          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: elements.length,
                itemBuilder: (_context, index){
                  return Card(
                      elevation: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),

                              child: Row(
                                children: [
                                  Text(elements[index].toString().substring(0, elements[index].toString().length - 18 ),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(_context).primaryColorDark),),
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child:  IconButton(
                                      icon: const Icon(Icons.add_alarm, color: Colors.pink,),
                                      onPressed: () => {
                                        NotificationApi.showScheduledNotification(
                                            scheduledDate: elements[index].dateTime.subtract(const Duration(minutes: 15)),
                                            title: elements[index].toString().substring(0, elements[index].toString().length - 18),
                                            body: 'Exam starts in 15 minutes'
                                        ),
                                        ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('You will be reminded 15 minutes before the exam')))
                                      },

                                      tooltip: 'Remind me',
                                    ),
                                  ),

                                ],

                              )
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            child: Text(elements[index].toString().substring(elements[index].toString().length - 18),
                                style: const TextStyle(color: Colors.black45)),
                          ),

                        ],
                      ));
                }
            ) ,
          )
        ],
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate ,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate ) {
      setState(() {
        selectedDate  = selected;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

}

