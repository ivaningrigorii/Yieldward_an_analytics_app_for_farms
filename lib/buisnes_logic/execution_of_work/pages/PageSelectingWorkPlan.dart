import 'package:flutter/material.dart';
import 'PageCreateWork.dart';
import 'PageExecutionWork.dart';



class PageSelectingWorkPlan extends StatefulWidget {
  const PageSelectingWorkPlan({Key? key}) : super(key: key);

  @override
  State<PageSelectingWorkPlan> createState() => _PageSelectingWorkPlanState();
}

class _PageSelectingWorkPlanState extends State<PageSelectingWorkPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый сезон работ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text('Создайте новое.\nИли выберете из старых.'),
            ),

            ElevatedButton(
              child: const Text('новое'),
              onPressed: () =>
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPageCreateField()),
                  ),
            ),
            ElevatedButton(
              child: const Text('выбор поля'),
              onPressed: () =>
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPageExecutionWorkList()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}










