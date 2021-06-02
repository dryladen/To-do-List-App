import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/model/Todo.dart';

/* Controller for the todo and date */
TextEditingController controllerTask = TextEditingController();
TextEditingController controllerTanggal = TextEditingController();
TextEditingController controllerJam = TextEditingController();

class _AddToDoState extends State<AddToDo> {
  @override
  void initState() {
    if (widget.isUpdate != false) {
      print("InitTodo");
      controllerTask.text = widget.task.task;
      controllerTanggal.text = widget.task.tanggal;
      controllerJam.text = widget.task.jam;
    }
  }

  void clearForm() {
    // controllerTask.text = task.task;
    controllerTask.clear();
    controllerTanggal.clear();
    controllerJam.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
            clearForm();
          },
        ),
        title: Text(
          "Tugas Baru",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* Jika tidak sedang update maka id tidak perlu di store karena akan dibuatkan database
          Jika sedang update id harus dimasukkan, agar tau dimana posisi data yang ingin diupdate */
          ToDo item = widget.isUpdate != true
              ? ToDo(
                  task: controllerTask.text,
                  tanggal: controllerTanggal.text,
                  jam: controllerJam.text,
                  isDone: false)
              : ToDo(
                  id: widget.task.id,
                  task: controllerTask.text,
                  tanggal: controllerTanggal.text,
                  jam: controllerJam.text,
                  isDone: false);
          Navigator.pop(context, item);
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

class _BodyInputState extends State<BodyInput> {
  Widget headerForm(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline2,
    );
  }

  DateTime tanggal = DateTime.now(); // Mengambil waktu saat ini
  final DateFormat formatTanggal =
      DateFormat('MMM dd, yyyy'); // Mengatur format

  Future<void> showTanggal() async {
    final DateTime date = await showDatePicker(
        helpText: "Pilih tanggal",
        context: context,
        initialDate: tanggal,
        firstDate: DateTime(2010), // batas awal tahun
        lastDate: DateTime(2022)); // batas akhir tahun
    setState(() {
      if (date != null) {
        tanggal = date;
      }
    });
    controllerTanggal.text = formatTanggal.format(date);
  }

  Future<void> showJam() async {
    final TimeOfDay result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    setState(() {
      if (result != null) {
        controllerJam.text = result.format(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Form bagian mengisi todo */
          headerForm("Apa yang ingin dikerjakan?"),
          FormTodo(
            hintText: "Mau Ngapain?",
            controller: controllerTask,
            icon: Icons.notes,
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          // Form bagian mengisi tanggal
          headerForm("Tanggal Kegiatan"),
          Padding(padding: EdgeInsets.only(top: 10)),
          MyTextForm(
            onTap: showTanggal,
            controller: controllerTanggal,
            hintText: "Tanggal Belum Ditentukan",
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          controllerTanggal.text != ""
              ? Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerForm("Waktu Kegiatan"),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    MyTextForm(
                      onTap: showJam,
                      controller: controllerJam,
                      hintText: "Jam Belum Ditentukan",
                    ),
                  ],
                )
              : Text(""),
        ],
      ),
    );
  }
}

class MyTextForm extends StatefulWidget {
  void Function() onTap;
  TextEditingController controller;
  String hintText;

  MyTextForm({this.onTap, this.controller, this.hintText});
  @override
  _TextFormState createState() => _TextFormState();
}

class _TextFormState extends State<MyTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      controller: widget.controller,
      readOnly: true,
      onTap: widget.onTap,
      decoration: InputDecoration(
          icon: Icon(
            Icons.date_range_rounded,
            color: Colors.tealAccent.shade100,
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyText1,
          contentPadding: EdgeInsets.only(bottom: 2),
          isDense: true,
          filled: true,
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2)),
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 3))),
    );
  }
}

// ignore: must_be_immutable

class FormTodo extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  IconData icon;

  FormTodo({this.hintText, this.controller, this.icon});
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Form(
        key: _formkey,
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Colors.tealAccent.shade100,
              ),
              hintText: hintText,
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

class AddToDo extends StatefulWidget {
  bool isUpdate;
  ToDo task;
  AddToDo({this.isUpdate = false, this.task});

  @override
  _AddToDoState createState() => _AddToDoState();
}

class BodyInput extends StatefulWidget {
  @override
  _BodyInputState createState() => _BodyInputState();
}
