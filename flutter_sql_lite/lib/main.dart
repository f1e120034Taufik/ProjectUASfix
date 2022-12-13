import 'package:flutter/material.dart';
import 'package:flutter_sql_lite/dashboard.dart';
import 'package:flutter_sql_lite/login.dart';
import 'package:flutter_sql_lite/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/dashboard': (context) => Dashboard(),
          //'/settings': (context) => Settings(),
          //'/tambahtugas': (context) => TambahTugas(),
        });
  }
}
