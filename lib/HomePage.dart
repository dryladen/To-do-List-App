import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/ToDoPage.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/services/db_helper.dart';

class _HomePageState extends State<HomePage> {
/* Variable untuk menyimpan atribut dari database untuk digunakan selama app berjalan */
  List<ToDo> tasks = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  Color white = Colors.white;

  @override
  void initState() {
    refresh();
    super.initState();
    print("InitState");
  }

  void popMenuItemAction(String value) {
    if (value == "About") {
      showAboutDialog(
          context: context,
          applicationIcon: Image.asset(
            "assets/img/ketua.png",
            height: 50,
          ),
          applicationName: "ToDo List App",
          applicationVersion: "1.0.0",
          children: [Text("Ini adalah aplikasi untuk UAS Pemrograman Mobile")]);
    }
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
          /* SEMENTARA AJA, BUAT NGETEST DATABASE */
          PopupMenuButton(
              onSelected: (value) {
                popMenuItemAction(value);
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("About"),
                      height: 10,
                      value: "About",
                    )
                  ])
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
              context,
              MaterialPageRoute(
                  fullscreenDialog: true, builder: (context) => AddToDo()));
          _save(items);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void refresh() async {
    try {
      List<Map<dynamic, dynamic>> _results = await DB.query(ToDo.table);
      tasks = _results.map((item) => ToDo.fromMap(item)).toList();
      DateTime.parse("${tasks[0].tanggal} 13:00:00");
    } catch (e) {
      print(e);
    }
    print(Timeline.now);

    setState(() {});
  }

  void _save(ToDo item) async {
    if (item != null) {
      await DB.insert(ToDo.table, item);
      refresh();
      setState(() {});
      _listKey.currentState.insertItem(tasks.length - 1);
    }
  }

  void _update(ToDo task) async {
    ToDo items = await Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => AddToDo(
                  task: task,
                  isUpdate: true,
                )));
    try {
      await DB.update(ToDo.table, items);
    } catch (er) {
      print(er);
    }
    refresh();
  }

  void _delete(ToDo item, int index) async {
    var task = tasks.removeAt(index);
    _listKey.currentState.removeItem(index, (context, animation) {
      return FadeTransition(
        opacity: animation,
        child: _buildItem(task),
      );
    });
    DB.delete(ToDo.table, item);
    refresh();
  }

  Widget _buildItem(ToDo tasks, [int index]) {
    return Container(
      /* Menambah margin untuk list item paling terakhir */
      
      margin: index != this.tasks.length - 1
          ? EdgeInsets.fromLTRB(10, 10, 10, 5)
          : EdgeInsets.fromLTRB(10, 10, 10, 60),
      decoration: BoxDecoration(
          color: Colors.teal.shade300, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
          onTap: () => _update(tasks),
          key: ValueKey<ToDo>(tasks),
          title: Text(
            /* Menampilkan teks dari task */
            '${tasks.task}',
            style: Theme.of(context).textTheme.headline3,
          ),
          subtitle: tasks.tanggal != ""
              ? Row(
                  children: [
                    /* Menampilkan teks tanggal */

                    Text(
                        tasks.jam != ""
                            ? '${tasks.tanggal}  -  ${tasks.jam}'
                            : '${tasks.tanggal}',
                        style: Theme.of(context).textTheme.headline4),
                  ],
                )
              : null,
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
