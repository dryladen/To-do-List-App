import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/main.dart';
import 'package:todo/model/Todo.dart';

/* Controller for the todo and date */
TextEditingController controllerTask = TextEditingController();
TextEditingController controllerTanggal = TextEditingController();
TextEditingController controllerJam = TextEditingController();
DateTime dateTime = DateTime(9000);
String jam24 = "23:59:59";
String yMMd = "9000-01-01";
bool isUpdating = false;
bool isJamVisible = false;

class _AddToDoState extends State<AddToDo> {
  @override
  void initState() {
    if (widget.isUpdate != false) {
      controllerTask.text = widget.task.task;
      controllerTanggal.text = widget.task.tanggal;
      controllerJam.text = widget.task.jam;
      isUpdating = widget.isUpdate;
      dateTime = widget.task.dateTime;
      yMMd = DateFormat("y-MM-dd").format(widget.task.dateTime);
      super.initState();
    }
  }

  TextButton textButton() {
    return TextButton(
        onPressed: () {},
        child: Text("Tambah"),
        style: TextButton.styleFrom(
            backgroundColor: MyApp().blueMain,
            primary: Colors.white,
            padding: EdgeInsets.zero,
            elevation: 20,
            fixedSize: Size.fromHeight(20)));
  }

  IconButton iconButton() {
    return IconButton(
      icon: Icon(Icons.check),
      alignment: Alignment.centerLeft,
      splashRadius: 15,
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
    );
  }

  void clearForm() {
    print("Clear");
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
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        clearForm();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              clearForm();
              Navigator.pop(context);
            },
          ),
          actions: [iconButton()],
          title: Text(
            widget.isUpdate != true ? "Tugas Baru" : "Update Kegiatan",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: BodyInput(),
      ),
    );
  }
}

class _BodyInputState extends State<BodyInput> {
/* 
?██████╗  █████╗ ████████╗███████╗████████╗██╗███╗   ███╗███████╗
?██╔══██╗██╔══██╗╚══██╔══╝██╔════╝╚══██╔══╝██║████╗ ████║██╔════╝
?██║  ██║███████║   ██║   █████╗     ██║   ██║██╔████╔██║█████╗  
?██║  ██║██╔══██║   ██║   ██╔══╝     ██║   ██║██║╚██╔╝██║██╔══╝  
?██████╔╝██║  ██║   ██║   ███████╗   ██║   ██║██║ ╚═╝ ██║███████╗
?╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝   ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝
*/
  DateTime dateTimeNow = DateTime.now();
  final DateFormat formatTanggal = DateFormat('MMM d, y'); // Mengatur format

  Future<void> showTanggal() async {
    final DateTime date = await showDatePicker(
      helpText: "Pilih tanggal",
      context: context,
      initialDate: dateTimeNow,

      firstDate: DateTime(2020), // batas awal tahun
      lastDate: DateTime(9000),
    ); // batas akhir tahun
    setState(() {
      if (date != null) {
        /* Show to interface */
        controllerTanggal.text = formatTanggal.format(date); /* Jun 23, 2023 */
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
      helpText: "Atur Waktu Kegiatan",
    );

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

/* 
!██╗    ██╗██╗██████╗  ██████╗ ███████╗████████╗
!██║    ██║██║██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝
!██║ █╗ ██║██║██║  ██║██║  ███╗█████╗     ██║   
!██║███╗██║██║██║  ██║██║   ██║██╔══╝     ██║   
!╚███╔███╔╝██║██████╔╝╚██████╔╝███████╗   ██║   
! ╚══╝╚══╝ ╚═╝╚═════╝  ╚═════╝ ╚══════╝   ╚═╝ 
*/
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
          DateTimeForm(
            onTap: showTanggal,
            controller: controllerTanggal,
            hintText: "Tanggal Belum Ditentukan",
            iconData: Icons.date_range_rounded,
            iconButton: iconBtnX(controllerTanggal),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Visibility(
              maintainState: true,
              visible: controllerTanggal.text != "",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerForm("Waktu Kegiatan"),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  DateTimeForm(
                    onTap: showJam,
                    controller: controllerJam,
                    hintText: "Jam Belum Ditentukan",
                    iconData: Icons.access_time_outlined,
                    iconButton: iconBtnX(controllerJam),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget headerForm(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline2,
    );
  }

  Widget iconBtnX(TextEditingController controller) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(maxHeight: 20, maxWidth: 20),
      icon: Icon(Icons.close),
      color: Colors.white,
      iconSize: 20,
      onPressed: () {
        if (controller == controllerTanggal) {
          controllerTanggal.text = "";
          controllerJam.text = "";
        } else {
          controllerJam.text = "";
        }
        setState(() {});
      },
    );
  }
}

/* 
*██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
*██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
*██║██╔██╗ ██║██████╔╝██║   ██║   ██║   
*██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   
*██║██║ ╚████║██║     ╚██████╔╝   ██║   
*╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝ 
 */

/* Class of Form Task (The first one) */

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
              fillColor: Colors.transparent,
              icon: Icon(icon,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor),
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

/* Class for date form and time form (The second and the third one) */
class _DateTimeFormState extends State<DateTimeForm> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: TextFormField(
            style: TextStyle(
                color: dateTime.isBefore(DateTime(
                        now.year, now.month, now.day, now.hour, now.minute))
                    ? Colors.red
                    : Colors.white,
                fontWeight: FontWeight.w600),
            controller: widget.controller,
            readOnly: true,
            onTap: widget.onTap,
            decoration: InputDecoration(
                fillColor: Colors.transparent,
                icon: Icon(
                  widget.iconData,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
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
          ),
        ),
        widget.controller.text != "" ? widget.iconButton : Text("")
      ],
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
class DateTimeForm extends StatefulWidget {
  void Function() onTap;
  TextEditingController controller;
  String hintText;
  IconData iconData;
  IconButton iconButton;

  DateTimeForm(
      {this.onTap,
      this.controller,
      this.hintText,
      this.iconData,
      this.iconButton});
  @override
  _DateTimeFormState createState() => _DateTimeFormState();
}
