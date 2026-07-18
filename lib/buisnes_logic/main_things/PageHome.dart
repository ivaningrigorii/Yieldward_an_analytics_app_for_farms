import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';

class MainPageHome extends StatelessWidget {
  const MainPageHome({super.key});

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = File('$dir/$filename');
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фермерство',),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/nature.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }}
