import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/ToDoPage.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/services/db_helper.dart';

class _HomePageState extends State<HomePage> {
/* Variable untuk menyimpan atribut dari database untuk digunakan selama app berjalan */
  List<ToDo> tasks = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  Color white = Colors.white;

  Timer timer;
  int count = 0;
  bool isHeading = false;
  String savedHeading = " ";
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final yesterday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second);
  final tommorow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  @override
  void initState() {
    refresh();
    super.initState();
    print("InitState");
  }

  @override
  void dispose() {
    super.dispose();
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
          : RefreshIndicator(
              key: _refreshKey,
              child: listView(),
              onRefresh: () async {
                _refreshKey.currentState.show(
                  atTop: true,
                );
                await Future.delayed(Duration(seconds: 2));
                setState(() {});
                // listView();
                print("Refresh");
              }),
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

  String subtitleText(ToDo task) {
    String text;
    final dateCheck =
        DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);
    if (task.dateTime.isBefore(DateTime.now())) {
      text = "Sudah Lewat, ${task.tanggal}";
    } else if (dateCheck == today) {
      text = "Hari ini";
    } else if (dateCheck == tommorow) {
      text = "Besok";
    } else {
      text = task.tanggal;
    }

    if (task.jam != "") {
      text += " - ${task.jam}";
    }

    return text;
  }

  String headingTask(ToDo task, [int index]) {
    String text;
    final dateCheck =
        DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);
    if (task.dateTime.isBefore(DateTime.now())) {
      text = "Sudah Lewat";
    } else if (dateCheck == today) {
      text = "Hari ini";
    } else if (dateCheck == tommorow) {
      text = "Besok";
    } else if (dateCheck == DateTime(9000, 1, 1)) {
      text = "Tidak Ada Tanggal";
    } else {
      text = "Nanti";
    }

    savedHeading = text;

    if (index == tasks.length - 1) {
      savedHeading = " ";
    }
    return text;
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
          applicationVersion: "1.0.2",
          children: [
            Center(child: Text("Kelompok 6 - Oozma Kappa")),
            Text("1915016069 - Delfan Rynaldo Laden"),
            Text("1915016074 - Oktavian Yoga"),
            Text("1915016093 - Muhammad Irvansyah")
          ]);
    }
  }

  void refresh() async {
    try {
      List<Map<dynamic, dynamic>> _results = await DB.query(ToDo.table);
      tasks = _results.map((item) => ToDo.fromMap(item)).toList();
      tasks.sort((x, y) => x.dateTime.compareTo(y.dateTime));
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  void _save(ToDo item) async {
    if (item != null) {
      print("Tidak Null");
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
    if (items != null) {
      try {
        await DB.update(ToDo.table, items);
      } catch (er) {
        print(er);
      }
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

  /* List of todo */
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
                    Text(subtitleText(tasks),
                        style: subtitleText(tasks).contains("Sudah Lewat")
                            ? Theme.of(context).textTheme.headline6
                            : Theme.of(context).textTheme.headline4),
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

  /* Generate the listview of Heading Text and   */
  listView() {
    return AnimatedList(
      physics: const AlwaysScrollableScrollPhysics(),
      key: _listKey,
      initialItemCount: tasks.length,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              savedHeading != headingTask(tasks[index], index)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        headingTask(tasks[index], index),
                        style: TextStyle(
                            color: headingTask(tasks[index], index) ==
                                    "Sudah Lewat"
                                ? Colors.red
                                : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                      ),
                    )
                  : Padding(padding: EdgeInsets.only(top: 0)),
              _buildItem(tasks[index], index)
            ],
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
