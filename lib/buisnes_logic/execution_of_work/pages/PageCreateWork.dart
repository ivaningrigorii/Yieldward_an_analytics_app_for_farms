import 'package:flutter/material.dart';
import 'package:fproject/main.dart';
import '../../../data_logic/models/dbfield.dart';
import 'PageExecutionWork.dart';


class MainPageCreateField extends StatefulWidget {
  const MainPageCreateField({Key? key}) : super(key: key);

  @override
  State<MainPageCreateField> createState() => CreateField_Page1State();
}

class CreateField_Page1State extends State<MainPageCreateField> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController regionController = TextEditingController();

  void addField(String description, String region) {
    insertField(Field(description: description, region: region));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Сезонные и важные работы'),
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage(page: 'home'))
              );
            },
          ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание, например, обработка полей 2026 лето',
                  ),
                ),
                TextField(
                  controller: regionController,
                  decoration: const InputDecoration(
                    labelText: 'Местность, например, Липецкая область',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addField(descriptionController.text, regionController.text);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainPageExecutionWorkList())
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