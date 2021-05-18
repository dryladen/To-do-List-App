import 'package:flutter/material.dart';
import 'package:todo/ToDoPage.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/services/db_helper.dart';

// String _task;
String tanggal;
List<ToDo> _tasks = [];
void refresh() async {
  List<Map<String, dynamic>> _results = await DB.query(ToDo.table);
  _tasks = _results.map((item) => ToDo.fromMap(item)).toList();
  print(_tasks.length);
  for (int i = 0;  i<_tasks.length;i++){
    print('$i. ${_tasks[i].task}');
  }
  print("SUDAH REFRESH");
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    refresh();
    super.initState();
  }

  ListView listView() {
    return ListView.builder(
        itemCount: _tasks.length == null ? 0 : _tasks.length,
        itemBuilder: (context, index) {
          return Items(index: index);
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
      body: _tasks.length == 0
          ? Center(
              child: Image.asset(
              'assets/img/Koala.png',
              height: 90,
            ))
          : listView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(_createRoute());
        },
        child: Icon(Icons.add),
      ),
    );
  }
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
          '${_tasks[widget.index].task}',
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.date_range_sharp,
              size: 17.0,
              color: Colors.white,
            ),
            Text('${_tasks[widget.index].tanggal}', style: Theme.of(context).textTheme.headline4),
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Items extends StatefulWidget {
  int index;
  Items({this.index});

  @override
  _ItemsState createState() => _ItemsState();
}
