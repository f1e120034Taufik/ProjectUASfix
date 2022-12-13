import 'package:flutter/material.dart';

import 'helpers/dbHelper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String dataUser = "";
  @override
  Widget build(BuildContext context) {
    String username = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Container(
          constraints: BoxConstraints.expand(),
          // is used to create container full screen with filled content.
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
              child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    DbHelper dbHelper = new DbHelper();
                    dbHelper.selectAllUser().then((mapList) {
                      mapList.forEach((element) {
                        setState(() {
                          dataUser = dataUser + "username: " + username + "\n";
                        });
                      });
                    });
                  },
                  child: Text('Print All Users')),
              Container(
                child: Text(dataUser),
              )
            ],
          ))),
    );
  }
}
