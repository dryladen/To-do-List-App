import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/model/Todo.dart';

/* Controller for the todo and date */
TextEditingController controllerTask = TextEditingController();
TextEditingController controllerTanggal = TextEditingController();
TextEditingController controllerJam = TextEditingController();
DateTime dateTime = DateTime(9000);
String jam24 = "23:59:59";
String yMMd = "9000-01-01";
bool isUpdating = false;

class _AddToDoState extends State<AddToDo> {
  @override
  void initState() {
    if (widget.isUpdate != false) {
      controllerTask.text = widget.task.task;
      controllerTanggal.text = widget.task.tanggal;
      controllerJam.text = widget.task.jam;
      isUpdating = widget.isUpdate;
      dateTime = widget.task.dateTime;
      super.initState();
    }
  }

  void clearForm() {
    // controllerTask.text = task.task;
    controllerTask.clear();
    controllerTanggal.clear();
    controllerJam.clear();
    /* Cuz list of itme will be sorted, so for the list that did have date, will be go to the bottom 
    The DateTime set to 9000 cuz it will more bigger then current year.
    */
    dateTime = DateTime(9000);
    jam24 = "23:59:59";
    yMMd = "9000-01-01";
    isUpdating = false;
  }

  final todoNull = SnackBar(content: Text("Kegiatan tidak boleh kosong"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            Navigator.pop(context);
            clearForm();
          },
        ),
        title: Text(
          widget.isUpdate != true ? "Tugas Baru" : "Update Kegiatan",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* Jika tidak sedang update maka id tidak perlu di store karena akan dibuatkan database
          Jika sedang update id harus dimasukkan, agar tau dimana posisi data yang ingin diupdate */
          if (controllerTask.text == "") {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(todoNull);
            return;
          }
          ToDo item = widget.isUpdate != true
              ? ToDo(
                  task: controllerTask.text,
                  tanggal: controllerTanggal.text,
                  jam: controllerJam.text,
                  dateTime: dateTime,
                  isDone: false)
              : ToDo(
                  id: widget.task.id,
                  task: controllerTask.text,
                  tanggal: controllerTanggal.text,
                  jam: controllerJam.text,
                  dateTime: dateTime,
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

  DateTime dateTimeNow = DateTime.now();
  final DateFormat formatTanggal = DateFormat('MMM d, y'); // Mengatur format

  Future<void> showTanggal() async {
    final DateTime date = await showDatePicker(
        helpText: "Pilih tanggal",
        context: context,
        initialDate: isUpdating != false ? dateTime : dateTimeNow,
        firstDate: DateTime(2020), // batas awal tahun
        lastDate: DateTime(9000)); // batas akhir tahun
    setState(() {
      if (date != null) {
        /* Show to interface */
        controllerTanggal.text = formatTanggal.format(date); /* Jun 23, 2023 */
        print(date);
        /* For comparing */
        yMMd = DateFormat("y-MM-dd").format(date);
        dateTime = DateTime.parse("$yMMd $jam24");
      }
    });
  }

  Future<void> showJam() async {
    final TimeOfDay result = await showTimePicker(
        context: context,
        initialTime: isUpdating != true
            ? TimeOfDay.now()
            : TimeOfDay.fromDateTime(dateTime),
        helpText: "Atur Waktu Kegiatan");

    setState(() {
      if (result != null) {
        var jamFormat = result.toString(); /* TimeOfDay(10:00) */

        /* Use regex to get the time inside parentheses */
        var listJam = jamFormat.split(RegExp(r"[\(+\)]")); /* 10:00 */

        jam24 = listJam[1] + ":00";

        dateTime = DateTime.parse("$yMMd $jam24");

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
            iconData: Icons.date_range_rounded,
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
                        iconData: Icons.access_time_outlined),
                  ],
                )
              : Text(""),
        ],
      ),
    );
  }
}
/* Class for date form and time form (The second and the third one) */
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
            widget.iconData,
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

/* Class of Form Task (The first one) */

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

// ignore: must_be_immutable
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

// ignore: must_be_immutable
class MyTextForm extends StatefulWidget {
  void Function() onTap;
  TextEditingController controller;
  String hintText;
  IconData iconData;

  MyTextForm({this.onTap, this.controller, this.hintText, this.iconData});
  @override
  _TextFormState createState() => _TextFormState();
}
