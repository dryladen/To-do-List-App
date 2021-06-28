import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/services/db_helper.dart';
import 'package:todo/HomePage.dart';
import 'package:todo/model/transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* Inisialisasi Database
  Mulai dari menentukan lokasi database,
  sampai membuat tabel beserta atribut didalamnya */
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color header = Color(0xff1E1E1E);
  Color main = Color(0xff292A2D);
  Color blueMain = Color(0xff8bd3e1);

  MaterialColor myColor = MaterialColor(0xff8bd3e1, {
    50: Color(0xffF1FAFB),
    100: Color(0xffDCF2F6),
    200: Color(0xffC5E9F0),
    300: Color(0xffAEE0EA),
    400: Color(0xff9CDAE6),
    500: Color(0xff8BD3E1),
    600: Color(0xff83CEDD),
    700: Color(0xff78C8D9),
    800: Color(0xff6EC2D5),
    900: Color(0xff5BB7CD),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDoList',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('id', ''),
        ],
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: myColor,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: RotationFadeTransitionBuilder()
          }),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.white, foregroundColor: main),
          /* Header */
          primaryColor: header,
          /* Main */
          backgroundColor: main,
          textTheme: TextTheme(
              overline: TextStyle(fontSize: 15),
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
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
              headline5: TextStyle(fontSize: 13, color: Colors.white),
              headline6: TextStyle(
                  /* Date Stryle if passed */
                  color: Colors.red.shade900,
                  fontSize: 13)),
        ),
        home: HomePage());
  }
}
