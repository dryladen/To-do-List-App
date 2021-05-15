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
        title: Text(
          "To-do List App",
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          Icon(Icons.search),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
      body: data.length == 0
          ? Center(
              child: Image.asset(
              'assets/img/Koala.png',
              height: 90,
            ))
          : ListView.builder(
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

class Items extends StatefulWidget {
  int index;
  Items({this.index});

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
          color: Colors.teal.shade300, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: Icon(
          Icons.tag_faces,
          color: Colors.white,
        ),
        title: Text(
          '${data[widget.index]['ToDo']}',
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.date_range_sharp,
              size: 17.0,
              color: Colors.white,
            ),
            Text('${data[widget.index]['Tanggal']}',
                style: Theme.of(context).textTheme.headline4),
          ],
        ),
        onTap: () {
          setState(() {
            this.value = !value;
          });
        },
        trailing: Checkbox(
          focusColor: Colors.green,
          // side: BorderSide(color: Colors.teal.shade300),
          value: value,
          onChanged: (value) {
            setState(() {
              this.value = value;
            });
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
