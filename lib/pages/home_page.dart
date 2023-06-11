import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lugat/pages/detail_page.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> words = [];
  List<Map<String, dynamic>> displayList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadWords();
  }

  bool isLoading = false;
  loadWords() async {
    setState(() {
      isLoading = true;
    });

    Database database = await openDatabase('my_database.db');

    //Ma'lumotlarni chaqirish
    words = await database.query('my_table');

    setState(() {
      isLoading = false;
      displayList = List.from(words);
    });

    await database.close();
  }

  searchWord(String value) {
    setState(() {
      displayList = words
          .where((element) => element["name"]
              .toString()
              .toLowerCase()
              .startsWith(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF006FFF),
          title: Text("IT Lug'at"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: TextField(
                onChanged: (value) => searchWord(value),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF006FFF),
                  ),
                  // hintText: "Qidiryotgan so'zingizni yozing",
                  hintStyle:
                      TextStyle(color: Color(0xFF006FFF).withOpacity(0.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Color(0xFF006FFF), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(0xFFE0E0E0),
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF006FFF), width: 3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) => SizedBox(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                          name: displayList[index]["name"],
                                          des: displayList[index]
                                              ["description"])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  color: Color(0xFF006FFF),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      displayList[index]["name"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            ),
                          ),
                        )),
              ),
            ),
          ],
        ));
  }
}
