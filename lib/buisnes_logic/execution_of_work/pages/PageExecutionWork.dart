import 'package:flutter/material.dart';
import 'package:fproject/main.dart';
import 'package:fproject/navigation_provider.dart';
import 'package:provider/provider.dart';
import '../../../data_logic/models/dbfield.dart';

import '../tasks/PagesFieldWork.dart';


class MainPageExecutionWorkList extends StatefulWidget {
  const MainPageExecutionWorkList({Key? key}) : super(key: key);

  @override
  State<MainPageExecutionWorkList> createState() => MainPageExecutionWorkListState();
}

class MainPageExecutionWorkListState extends State<MainPageExecutionWorkList> {
  @override
  Widget build(BuildContext context) {
    final navigatorProvider = context.watch<NavigationProvider>();
    final int currentIndex = 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Проведение работ'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage(page: 'home'))
            );
          },
        )
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: ConstMainPageClasses,
          ),
          FutureBuilder(
              future: selectFieldsAll(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('--');
                }

                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Material(
                      elevation: 3.0,
                      shadowColor: Colors.blueGrey,
                      child: ListTile(
                        title: Text(snapshot.data![index].description),
                        subtitle: Text(snapshot.data![index].region),
                        textColor: Colors.black,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteField(snapshot.data![index].id);
                            setState(() {

                            });
                          },
                        ),
                        onTap: () =>
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MenuApp(
                                      description: snapshot.data![index].description,
                                      region: snapshot.data![index].region,
                                      id_field: snapshot.data![index].id,
                                    ),
                              ),
                            )
                        ,
                      ),
                    );
                  },
                );
              }

          ),
        ],
      ),
      bottomNavigationBar: getBottomNavigatorBar(navigatorProvider),
    );
  }
}
