import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/HomePage.dart';
import 'package:todo/model/Todo.dart';
import 'package:todo/services/db_helper.dart';
/* Controller for the todo and date */
TextEditingController controllerTask = TextEditingController();
TextEditingController controllerTanggal = TextEditingController();

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  void clearForm() {
    controllerTask.clear();
    controllerTanggal.clear();
  }

  void _save() async {
    ToDo item = ToDo(task: controllerTask.text, tanggal: controllerTanggal.text);
    await DB.insert(ToDo.table, item);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Tugas Baru",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _save();
          Navigator.of(context).pop();
          clearForm();
        },
        child: Icon(
          Icons.check,
        ),
      ),
      body: BodyInput(),
    );
  }
}

class BodyInput extends StatefulWidget {
  @override
  _BodyInputState createState() => _BodyInputState();
}

class _BodyInputState extends State<BodyInput> {
  DateTime tanggal = DateTime.now(); // Mengambil waktu saat ini
  final DateFormat formatTanggal =
      DateFormat('MMM dd, yyyy'); // Mengatur format

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Form bagian mengisi todo */
          Text(
            "Apa yang ingin dikerjakan?",
            style: Theme.of(context).textTheme.headline2,
          ),
          FormTodo(
            hintText: "Mau Ngapain?",
            controller: controllerTask,
            icon: Icons.notes,
          ),
          Padding(padding: EdgeInsets.only(top: 20)),

          // Form bagian mengisi tanggal
          Text(
            "Waktu dan Tanggal",
            style: Theme.of(context).textTheme.headline2,
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          TextFormField(
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            controller: controllerTanggal,
            onTap: () async {
              final DateTime date = await showDatePicker(
                  context: context,
                  initialDate: tanggal,
                  firstDate: DateTime(2010), // batas awal tahun
                  lastDate: DateTime(2022)); // batas akhir tahun
              setState(() {
                tanggal = date;
              });
              controllerTanggal.text = formatTanggal.format(date);
            },
            decoration: InputDecoration(
                icon: Icon(
                  Icons.date_range_rounded,
                  color: Colors.tealAccent.shade100,
                ),
                hintText:
                    formatTanggal.format(tanggal), // Menampilkan data saat ini
                hintStyle: Theme.of(context).textTheme.bodyText1,
                contentPadding: EdgeInsets.only(bottom: 2),
                isDense: true,
                filled: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 3))),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FormTodo extends StatefulWidget {
  String hintText;
  TextEditingController controller;
  IconData icon;

  FormTodo({this.hintText, this.controller, this.icon});

  @override
  _FormTodoState createState() => _FormTodoState();
}

class _FormTodoState extends State<FormTodo> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Form(
        key: _formkey,
        child: TextFormField(
          controller: widget.controller,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              icon: Icon(
                widget.icon,
                color: Colors.tealAccent.shade100,
              ),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyText1,
              contentPadding: EdgeInsets.only(bottom: 2),
              isDense: true,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 3))),
          validator: (String value) {
            if (value == null || value.isEmpty) {
              return "Harus Ada";
            }
            return null;
          },
        ),
      ),
    );
  }
}
