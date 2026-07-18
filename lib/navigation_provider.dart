import 'package:flutter/material.dart';

import 'buisnes_logic/execution_of_work/pages/PageCreateWork.dart';
import 'buisnes_logic/execution_of_work/pages/PageExecutionWork.dart';
import 'buisnes_logic/main_things/PageHome.dart';
import 'buisnes_logic/main_things/PageStatisticHome.dart';


final ConstMainPageClasses = [
  const MainPageHome(),
  const MainPageCreateField(),
  const MainPageExecutionWorkList(),
  const MainPageFarmStatistics()
];

BottomNavigationBar getBottomNavigatorBar(navigationProvider) {
  return BottomNavigationBar(
    currentIndex: navigationProvider.currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      navigationProvider.setTab(index);
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ближайшие',),
      BottomNavigationBarItem(icon: Icon(Icons.nature_people_outlined), label: 'Новые работы',),
      BottomNavigationBarItem(icon: Icon(Icons.nature_people_rounded), label: 'Проведение работ',),
      BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Результаты'),
    ],
  );
}

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}