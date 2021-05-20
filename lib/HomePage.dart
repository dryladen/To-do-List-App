import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/ToDoPage.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/services/db_helper.dart';

/* Variable untuk menyimpan atribut dari database untuk digunakan selama app berjalan */

/* Untuk merefresh database dan dimasukkan ke variable tasks */
List<ToDo> tasks = [];

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  Color white = Colors.white;

  @override
  void initState() {
    refresh();
    super.initState();
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
          Icon(Icons.check),
          /* SEMENTARA AJA, BUAT NGETEST DATABASE */
          IconButton(
              onPressed: () async {}, icon: Icon(Icons.more_vert_rounded))
        ],
      ),
      /* Jika tidak ada sesuatu di dalam database maka akan ditampilkan gambar koala, jika tidak tampilkan list todo */
      body: tasks.length == 0
          ? Center(
              child: Image.asset(
              'assets/img/Koala.png',
              height: 90,
            ))
          : listView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /* Pindah ke halaman selanjutnya sambil menunggu kembalian dari halaman selanjutnya dan akan dimasukkan kedalam database */
          ToDo items = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddToDo()));
          _save(items);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(ToDo.table);
    tasks = _results.map((item) => ToDo.fromMap(item)).toList();
    for (int i = 0; i < tasks.length; i++) {
      print('$i. ${tasks[i].isDone} ');
    }

    setState(() {});
  }

  void _save(ToDo item) async {
    if (item != null) {
      await DB.insert(ToDo.table, item);
      refresh();
      _listKey.currentState.insertItem(tasks.length - 1);
      setState(() {});
    }
  }

  void _delete(ToDo item, int index) async {
    var task = tasks.removeAt(index);
    _listKey.currentState.removeItem(index, (context, animation) {
      return FadeTransition(
        opacity: animation,
        child: _buildItem(task),
      );
    });
    // DB.delete(ToDo.table, item);
    // refresh();
  }

  Widget _buildItem(ToDo tasks, [int index]) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
          color: Colors.teal.shade300, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
          key: ValueKey<ToDo>(tasks),
          title: Text(
            /* Menampilkan teks dari task */
            '${tasks.task}',
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: Row(
            children: [
              /* Menampilkan teks tanggal */
              Text('${tasks.tanggal}  -  ${tasks.jam}',
                  style: Theme.of(context).textTheme.headline4),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                tasks.isDone = true;
              });
              _delete(tasks, index);
            },
            icon: tasks.isDone != true
                ? Icon(
                    Icons.radio_button_off_rounded,
                    color: white,
                  )
                : Icon(
                    Icons.check_circle,
                    color: white,
                  ),
          )),
    );
  }

  listView() {
    return AnimatedList(
      key: _listKey,
      initialItemCount: tasks.length,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildItem(tasks[index], index),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
