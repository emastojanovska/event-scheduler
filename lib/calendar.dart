import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'main.dart';

class CalendarPageWrapper extends StatefulWidget {
  CalendarPageWrapper({Key? key, required this.elements}) : super(key: key);

  List<Exam> elements;
  @override
  CalendarPage createState() => CalendarPage(elements: elements);
}

class CalendarPage extends State<CalendarPageWrapper> {
  CalendarPage({Key? key, required this.elements});

  List<Exam> elements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => {
            Navigator.pop(context)
          },
        ),

      ),
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 1,
        dataSource: ExamsDataSource(getAppointments()),
      ),
    );
  }


  List<Appointment> getAppointments(){
    List<Appointment> exams = <Appointment> [];
    for(var exam in elements){
      exams.add(Appointment(
          startTime: exam.dateTime,
          endTime: exam.dateTime.add(const Duration(hours: 2)),
          subject: exam.subject,
          color: Colors.pink
      ));
    }
    return exams;
  }
}

class ExamsDataSource extends CalendarDataSource{
  ExamsDataSource(List<Appointment> source){
    appointments = source;
  }
}

