import 'package:flutter/material.dart';
import 'package:fproject/data_logic/models/dbtypework.dart';
import '../../../data_logic/models/dbfiedlwork.dart';
import '../../../data_logic/models/dbfield.dart';

import '../../../main.dart';
import 'TaskCalendar.dart';


class MenuApp extends StatefulWidget {
  final int id_field;
  final String description;
  final String region;


  const MenuApp(
      {Key? key, required this.id_field, required this.description, required this.region}
      ) : super(key: key);

  @override
  State<MenuApp> createState() => MenuAppPage1();
}


class MenuAppPage1 extends State<MenuApp> {
  String? field_name;

  @override
  void initState() {
    getField(widget.id_field).then(
            (value) {
              field_name=value.description;
              setState(() {

              });

            }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ПОЛЕ:$field_name /ПЛАНЫ'),

        leading: IconButton(
          icon: const Icon(Icons.nature_people_rounded),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage(page: 'page2'))
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


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('Создание или просмотр планов работ'),
            ),


            ElevatedButton(
              child: Text('Планы обработки поля: $field_name'),
              onPressed: () =>
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ListWorks(
                        widget.id_field,
                        widget.description,
                        widget.region
                    )),
                  ),
            ),

            ElevatedButton(
              child: const Text('+ Создать новый план работ +'),
              onPressed: () =>
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CreateFieldWork(
                        widget.id_field,
                        widget.description,
                      widget.region
                    )),
                  ),
            ),

          ],
        ),
      ),
    );
  }
}








class CreateFieldWork extends StatefulWidget {
  final int id_field;
  final String description;
  final String region;

  const CreateFieldWork(this.id_field, this.description, this.region, {Key? key}) : super(key: key);

  @override
  State<CreateFieldWork> createState() => CreateWorkState(
    id_field, description, region
  );
}


class CreateWorkState extends State<CreateFieldWork> {
  final int id_field;
  final String description;
  final String region;
  var dropdownvalue;
  List<String> items = [];
  var typeworks;

  CreateWorkState(this.id_field, this.description, this.region);



  TextEditingController workloadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  _getItems() async {
    List<TypeWork> typeworks = await selectTypeWorksAll();
    setState(() {
      this.typeworks = typeworks;
      items = typeworks.map((e) => e.type_work).toList();
      if (items.isNotEmpty) {
        dropdownvalue = items[0];
      }
    }
    );
  }

  addField(var workload) async {
    int id_typework = typeworks.firstWhere((object) => object.type_work == dropdownvalue).id;
    insertFieldWork(FieldWork(workload: workload, id_field: id_field, id_typework: id_typework));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('ПОЛЕ:../ПЛАНЫ/СОЗДАНИЕ'),

        leading: IconButton(
          icon: const Icon(Icons.pending_actions),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MenuApp(

                      description: description,
                      region: region,
                      id_field: id_field,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Обрабатываемое поле: $description'),
                Text('Область: $region'),

                TextField(
                  controller: workloadController,
                  decoration: const InputDecoration(
                    labelText: 'Сколько обрабатывать? (в ГА)',
                  ),
                ),

                DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((var items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.toString()),
                    );
                  }).toList(),
                  onChanged: (var newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    addField(int.parse(workloadController.text.toString()));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ListWorks(
                                widget.id_field,
                                widget.description,
                                widget.region
                            ))
                    );
                  }
                  ,
                  child: const Text('Создать'),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


class ListWorks extends StatefulWidget {
  final int id_field;
  final String description;
  final String region;

  const ListWorks(this.id_field, this.description, this.region, {Key? key}) : super(key: key);

  @override
  State<ListWorks> createState() => ListFieldWorkssState(
      id_field, description, region
  );
}


class ListFieldWorkssState extends State<ListWorks> {
  final int id_field;
  final String description;
  final String region;

  ListFieldWorkssState(this.id_field, this.description, this.region);



  _deleteFieldWork(int id) {
    deleteFieldWork(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ПОЛЕ:../ПЛАНЫ/СОЗДАННЫЕ'),

        leading: IconButton(
          icon: const Icon(Icons.pending_actions),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MenuApp(

                      description: description,
                      region: region,
                      id_field: id_field,
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


      body: FutureBuilder(
        future: selectFieldWorksAll(id_field),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  elevation: 3.0,
                  shadowColor: Colors.blueGrey,
                  child: ListTile(
                    title: SpecialText(
                      id_typework: snapshot.data![index].id_typework, child: null,),
                    subtitle: SpecialTextField(
                      id_field: snapshot.data![index].id_field, child: null,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteFieldWork(snapshot.data![index].id);
                        setState(() {});
                      },
                    ),
                    onTap: () =>
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CalendarWidget_(fieldwork_id: snapshot.data![index].id,
                            field: snapshot.data![index].id_field, )),
                        ),
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
    );
  }
}


class SpecialText extends StatefulWidget {
  final Widget? child;
  final int id_typework;
  const SpecialText({Key? key, required this.id_typework, this.child, }) : super(key: key);

  @override
  State<SpecialText> createState() => SpecialTextState();
}


class SpecialTextState extends State<SpecialText> {
  TypeWork? typeWork;

  @override
  void initState() {
    super.initState();
    initText();
  }

  initText() async {
    await getTypeWork(widget.id_typework).then((value) => typeWork = value);
    setState(() {});
  }

  @override
  build(BuildContext context) {
    return Text('Тип работы: ${typeWork?.type_work}, \n ${typeWork?.cultures}');
  }
}


class SpecialTextField extends StatefulWidget {
  final Widget? child;
  final int id_field;
  const SpecialTextField({Key? key, required this.id_field, this.child, }) : super(key: key);

  @override
  State<SpecialTextField> createState() => SpecialTextFieldState();
}


class SpecialTextFieldState extends State<SpecialTextField> {
  Field? field;

  @override
  void initState() {
    super.initState();
    initText();
  }

  initText() async {
    await getField(widget.id_field).then((value) => field = value);
    setState(() {});
  }

  @override
  build(BuildContext context) {
    return Text('Поле: ${field?.description}, в ${field?.region}');
  }
}