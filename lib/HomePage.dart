import 'package:flutter/material.dart';
import 'package:todo/ToDoPage.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/services/db_helper.dart';

/* Variable untuk menyimpan atribut dari database untuk digunakan selama app berjalan */
List<ToDo> tasks = [];

/* Untuk merefresh database dan dimasukkan ke variable tasks */
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(ToDo.table);
    tasks = _results.map((item) => ToDo.fromMap(item)).toList();
    print(tasks.length);
    for (int i = 0; i < tasks.length; i++) {
      print('$i. ${tasks[i].task}');
    }
    print("SUDAH REFRESH");

    setState(() {});
  }

  void _save(ToDo item) async {
    if (item != null) {
      await DB.insert(ToDo.table, item);
      refresh();
    }
  }

  listView() {
    return ListView.builder(
        itemCount: tasks.length == null ? 0 : tasks.length,
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
          /* Menampilkan teks dari task */
          '${tasks[widget.index].task}',
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.date_range_sharp,
              size: 17.0,
              color: Colors.white,
            ),
            /* Menampilkan teks tanggal */
            Text('${tasks[widget.index].tanggal}',
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
