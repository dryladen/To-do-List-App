import 'package:flutter/material.dart';

import 'ToDo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int jumlahItems = 0;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Center(child: Text("To-do List App")),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: ListView(
        children: [
          for (var i = 0; i < jumlahItems; i++)
            Items(
              index: i,
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Items extends StatelessWidget {
  int index;

  Items({this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        title: Text(todo[index]),
        tileColor: Colors.cyan[200],
        subtitle: Text(tanggal[index]),
        trailing: Checkbox(
          value: true,
          onChanged: (value) {
            value = true;
          },
          activeColor: Colors.red,
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddToDo(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
