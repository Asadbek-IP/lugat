import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DetailsPage extends StatefulWidget {
  final String des;
  final String name;
  const DetailsPage({super.key, required this.des, required this.name});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF006FFF),
          title: Text("Ma'nosi"),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                  text: TextSpan(
                      text: widget.name + " - ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      children: [
                    TextSpan(
                      text: widget.des
                          .replaceAll("\\n", "\n")
                          .replaceAll("\\t", "  "),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    )
                  ]))),
        ));
  }
}
