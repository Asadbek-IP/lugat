import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lugat/pages/home_page.dart';
import 'package:sqflite/sqflite.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<bool> isTableEmpty(Database database, String tableName) async {
    final result = await database.rawQuery('SELECT COUNT(*) FROM $tableName');
    int? count = Sqflite.firstIntValue(result);
    return count == 0;
  }

  loadData() async {
    Database database = await openDatabase('my_database.db');
    await database.execute(
        'CREATE TABLE IF NOT EXISTS my_table (name TEXT, description TEXT)');
    if (await isTableEmpty(database, "my_table")) {
      String data = await rootBundle.loadString('assets/data.txt');

      List<String> lines = data.split('\n');

      for (String line in lines) {
        List<String> data = line.split("', '");

        String name = data[0].replaceAll("['", "");
        name = name.replaceAll("\\n", "");
        await database.insert('my_table',
            {'name': name, 'description': data[1].replaceAll("']", "")});
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0000FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 150,
              height: 150,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "IT Lug'at",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
