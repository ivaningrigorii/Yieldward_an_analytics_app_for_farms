import 'package:flutter/material.dart';
import 'package:fproject/data_logic/models/dbfield.dart';
import 'package:fproject/data_logic/models/dbwhether.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../wheather/wheather.dart';
import '../../../data_logic/models/dbtask.dart';
import '../../../data_logic/models/dbtypework.dart';
import '../../../main.dart';
import 'PagesFieldWork.dart';


class CalendarWidget_ extends StatefulWidget{
  final int fieldwork_id;
  final int field;

  const CalendarWidget_({super.key, required this.fieldwork_id, required this.field});

  @override
  State<CalendarWidget_> createState() => _TableEventsExampleState();

}


class _TableEventsExampleState extends State<CalendarWidget_> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Whether? whether;
  Field? field_object;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    getField(widget.field).then(
            (value) {
          field_object=value;
          setState(() {});

            });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget whetherAnalyz() {
    String text = 'Идеальные погодные условия.';
    ColorSwatch<int> color = Colors.green;

    if (whether!.temperature < 10
          || whether!.temperature >= 35) {
      text = 'Прохладно или жарко!';
      color = Colors.orangeAccent;
    }

    if (whether!.rainProbability > 70) {
      text = 'Высока вероятность осадков!';
      color = Colors.redAccent;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: color,
      child: Text(
        '$text \n${whether?.temperature.round()}°С, влажность: ${whether?.rainProbability.round()}'
      ),
    );
  }

  changeVals() {
    getField(widget.field).then((field) =>
        getWeatherForecast(field.region).then((value) {
          Map<String, dynamic>? listvals = {};
          listvals = (
              value.where((element) =>
              DateTime
                  .parse(element.values.toList()[0]).hour == 9 &&
                  DateTime.parse(element.values.toList()[0]).month == _selectedDay?.month &&
                  DateTime.parse(element.values.toList()[0]).day == _selectedDay?.day
              ).firstOrNull
          );

          if (listvals != null) {
            whether = Whether(
                dateTime_: listvals['dateTime'],
                temperature: listvals['temperature'],
                rainProbability: listvals['rainProbability']
            );
          } else {
              whether = null;
          }

            setState(() { });

        })
    );
  }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        changeVals();
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
      changeVals();
    });

  }

  Color _getColor(int? typeWork) {
    return switch (typeWork) {
      -1 => Colors.green,
      0 => Colors.brown,
      1 => Colors.brown,
      2 => Colors.brown,
      3 => Colors.cyan,
      4 => Colors.grey,
      5 => Colors.redAccent,
      6 => Colors.grey,
      7 => Colors.orangeAccent,
      _ => Colors.transparent
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ПОЛЕ:../ПЛАН/ЗАДАЧИ'),

        leading: IconButton(
          icon: const Icon(Icons.pending_actions),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ListWorks(widget.field,field_object!.description,field_object!.region,
                    ),
              ),
            );
          },
        ),

        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context)
              => MainPage(page: result)));},

            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                  value: 'home',
                  child: Row(
                    children: [
                      Text('Домой'),
                      Icon(Icons.home),
                    ],
                  )
              ),
              const PopupMenuItem(
                value: 'page1',
                child: Text('Новое'),
              ),
              const PopupMenuItem(
                value: 'page2',
                child: Text('В работе'),
              ),
              const PopupMenuItem(
                value: 'page3',
                child: Text('Аналитика'),
              ),
            ],
          ),
        ],
      ),


      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2026),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return FutureBuilder<int?>(
                  future: getTypeWorkByCalendarDate(day),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('${day.day}'));
                    }

                    final int? typeWork = snapshot.data;
                    Color dayColor = _getColor(typeWork);

                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: dayColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                );
              }

            ),

          ),
          const SizedBox(height: 8.0),

          ElevatedButton(
            onPressed: () {
              TextEditingController volumeOfFieldWorkController = TextEditingController();
              TextEditingController descriptionController = TextEditingController();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Создать задачу'),

                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Описание',
                              hintText: 'Пример: нужно провести ремонт трактора №1'
                            )
                          ),
                          TextField(
                              controller: volumeOfFieldWorkController,
                              decoration: const InputDecoration(
                                  labelText: 'Объём обработки в гектарах',
                                  hintText: 'Например, 5, (число, Га)'
                              )
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Отмена'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          String volumeOfFieldWork = volumeOfFieldWorkController.text;
                          String description = descriptionController.text;

                          if (volumeOfFieldWork.isNotEmpty) {
                            Task newTask = Task(
                              volume_of_fieldwork: int.parse(volumeOfFieldWork),
                              date_task: _selectedDay!.toIso8601String(),
                              exec: 0, id_fieldwork: widget.fieldwork_id,
                              description: descriptionController.toString()
                            );
                            insertTask(newTask);
                            setState(() {});
                            Navigator.of(context).pop();
                          } else {

                          }
                        },
                        child: const Text('Создать'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Добавить задачу'),
          ),

          const SizedBox(height: 8.0),

          whether == null?
          const Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            color: Colors.white30,
            child: Text('Данных о погоде нет'),
          ):
          whetherAnalyz(),

          const SizedBox(height: 8.0),

          FutureBuilder(
            future: selectTasksSome(widget.fieldwork_id, _selectedDay!),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Нужно обработать ${snapshot.data![index].volume_of_fieldwork} Га'),
                      subtitle: const Text('Задача'),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteTask(snapshot.data![index].id);
                              setState(() {});
                            },
                          ),
                          snapshot.data![index].exec==0 ?
                          IconButton(
                            icon: const Icon(Icons.panorama_fish_eye),
                            onPressed: () {
                              chageTaskExeck(snapshot.data![index].id, 1);
                              setState(() {});
                            },
                          ) :
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              chageTaskExeck(snapshot.data![index].id, 0);
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    );
                  },

                );
              }
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
            ,
          ),

        ],
      ),
    );
  }}