import 'package:flutter/material.dart';
import 'package:todo/HomePage.dart';

final controllerTodo = TextEditingController();
final controllerTanggal = TextEditingController();

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
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
          Map value = {
            'ToDo': controllerTodo.text,
            'Tanggal': controllerTanggal.text
          };
          controllerTodo.clear();
          controllerTanggal.clear();
          Navigator.pop(context, value);
        },
        child: Icon(Icons.check),
      ),
      body: BodyInput(),
    );
  }
}

class BodyInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apa yang ingin dikerjakan?",
            style: Theme.of(context).textTheme.headline2,
          ),
          FormTodo(
            hintText: "Mau Ngapain?",
            controller: controllerTodo,
            icon: Icons.notes,
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            "Tanggal dan Waktu",
            style: Theme.of(context).textTheme.headline2,
          ),
          FormTodo(
            hintText: "Belum ada tanggal",
            controller: controllerTanggal,
            icon: Icons.date_range_rounded,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FormTodo extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String hintText;
  TextEditingController controller;
  IconData icon;

  FormTodo({this.hintText, this.controller, this.icon});

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
