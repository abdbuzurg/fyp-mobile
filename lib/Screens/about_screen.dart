import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("About")),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Table(
              columnWidths: <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FlexColumnWidth()
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(children: [
                  Text("Version",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("1.0.0-beta14.0", style: TextStyle(fontSize: 16))
                ]),
                TableRow(children: [
                  Text("License",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("MIT", style: TextStyle(fontSize: 16))
                ]),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text("Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text(
                "The application is build by Abdulloev Buzurgmehr and Ozar Aini. The intention of the project is to help ease the search for transportation within Tajikistan. The app help doing that by providing a common ground for both a driver and a traveller to find each other easily. ")
          ]),
        ));
  }
}
