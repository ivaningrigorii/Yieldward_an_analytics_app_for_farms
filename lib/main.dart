import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigation_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const FieldworkManagementAppForFarming(),
    ),
  );
}

class FieldworkManagementAppForFarming extends StatelessWidget {
  const FieldworkManagementAppForFarming({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение фермерство',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainPage(page: 'home',),
    );
  }
}

class MainPage extends StatefulWidget {
  final String page;

  const MainPage({super.key, required this.page});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = ['home', 'page1', 'page2', 'page3'].indexOf(widget.page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    
    return Scaffold(
      body: IndexedStack(
        index: navigationProvider.currentIndex,
        children: ConstMainPageClasses,
      ),

      bottomNavigationBar: getBottomNavigatorBar(navigationProvider),
    );
  }
}




