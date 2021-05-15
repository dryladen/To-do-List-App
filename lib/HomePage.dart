import 'package:flutter/material.dart';

import 'ToDo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List data = [];

class _HomePageState extends State<HomePage> {
  void resValue(Map value) {
    setState(() {
      if (value != null) {
        data.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("To-do List App"),
        actions: [
          Icon(Icons.search),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
      body: data.length == 0 ? Center(child: Image.asset('assets/img/Koala.png',height: 90,)) : ListView.builder(
          itemCount: data.length == null ? 0 : data.length,
          itemBuilder: (context, index) {
            return Items(index: index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map res = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddToDo()));
          resValue(res);
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
              title: Text('${data[index]['ToDo']}'),
              tileColor: Colors.cyan[200],
              subtitle: Text('${data[index]['Tanggal']}'),
              trailing: Checkbox(
                value: false,
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
