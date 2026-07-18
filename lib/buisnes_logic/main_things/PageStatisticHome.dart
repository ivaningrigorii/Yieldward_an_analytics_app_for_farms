import 'package:fproject/data_logic/models/dbfiedlwork.dart';
import 'package:fproject/data_logic/models/dbfield.dart';
import 'package:fproject/data_logic/models/dbtypework.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import '../../main.dart';



class MainPageFarmStatistics extends StatefulWidget {
  const MainPageFarmStatistics({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<MainPageFarmStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Фермеская статистика'),

        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage(page: 'home'))
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
                child: Text('Результаты'),
              ),
            ],
          ),
        ],
      ),

      body:  Column(
        children: <Widget>[
          FutureBuilder(
            future: selectActivePlansStat(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data != null && snapshot.hasData) {
                return Expanded(child:
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        if (snapshot.data != null)
                          FutureBuilder(
                            future: getFieldWork(snapshot.data![index].id_fieldwork),
                            builder: (BuildContext context, AsyncSnapshot<FieldWork> snapshot2) {
                              return
                                Row(
                                  children: [
                                    const Text('       План:'),
                                    FutureBuilder(
                                      future: getTypeWork(snapshot2.data!.id_typework),
                                      builder: (BuildContext context, AsyncSnapshot<TypeWork> snapshot3) {
                                        return snapshot3.data!=null?
                                        Text(' ${snapshot3.data!.type_work.toString()}')
                                            :
                                        const Text('');
                                      },
                                    ),
                                    FutureBuilder(
                                      future: getField(snapshot2.data!.id_field),
                                      builder: (BuildContext context, AsyncSnapshot<Field> snapshot4) {
                                        return snapshot4.data != null?
                                        Text(', на поле ${snapshot4.data!.description}'):
                                        const Text('');
                                      },
                                    ),
                                  ],
                                );
                            },

                          ),


                        const Padding(padding: EdgeInsets.all(60)),

                        if (snapshot.data != null)
                          SizedBox(
                            height: 20,
                            child:
                            PieChart(PieChartData(
                                centerSpaceRadius: 10,
                                borderData: FlBorderData(show: true),
                                sections: [
                                  PieChartSectionData(
                                      value: snapshot.data![index].sum_t.toDouble(),
                                      color: Colors.green, radius: 100,
                                      title: 'обработано'),

                                  PieChartSectionData(

                                      value: snapshot.data![index].sum_f.toDouble(),
                                      color: Colors.yellow, radius: 100,
                                      title: 'в планах'),


                                  PieChartSectionData(value: (
                                      snapshot.data![index].workload.toDouble() -
                                          snapshot.data![index].sum_f.toDouble() -
                                          snapshot.data![index].sum_t.toDouble()

                                  ) , color: Colors.grey, radius: 100,
                                      title: 'осталось ${
                                          snapshot.data![index].workload.toDouble() -
                                              snapshot.data![index].sum_f.toDouble() -
                                              snapshot.data![index].sum_t.toDouble()
                                      }'),
                                ]),),

                          ),
                        const Padding(padding: EdgeInsets.all(70)),
                      ],
                    );
                  },
                )
                );
              }
              else {
                return Container();
              }
            }
            ,
          ),
        ],
      ),
    );
  }}