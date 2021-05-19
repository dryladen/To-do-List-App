import 'package:flutter/material.dart';
import 'package:todo/services/db_helper.dart';
import 'package:todo/HomePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  /* Inisialisasi Database
  Mulai dari menentukan lokasi database,
  sampai membuat tabel beserta atribut didalamnya */
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-do List App',
        theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal.shade700),
          primaryColor: Colors.teal,
          backgroundColor: Colors.teal.shade700,
          inputDecorationTheme: InputDecorationTheme(),
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white60),
              bodyText2: TextStyle(color: Colors.white),
              headline1: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              headline2: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900),
              headline3: TextStyle(
                  // title Style
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900),
              headline4: TextStyle(
                  // Date Style
                  color: Colors.white,
                  fontSize: 12)),
        ),
        home: HomePage());
  }
}
