import 'package:intl/intl.dart';
import 'package:todo/model/model.dart';

class ToDo extends Model {
  static String table = "todoTables";

  int id;
  String task;
  String tanggal;
  String jam;
  DateTime dateTime;
  bool isDone;

  ToDo(
      {this.id, this.task, this.tanggal, this.jam, this.isDone, this.dateTime});

  Map<String, dynamic> toMap() {
    String datetime = DateFormat("y-MM-d").format(this.dateTime);
    print(datetime);
    Map<String, dynamic> map = {
      'task': task,
      'tanggal': tanggal,
      'jam': jam,
      'dateTime': datetime,
      'isDone': isDone
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static ToDo fromMap(Map<dynamic, dynamic> map) {
    DateTime datetime = DateFormat("y-MM-d").parse(map['dateTime']);
    return ToDo(
        id: map['id'],
        task: map['task'].toString(),
        tanggal: map['tanggal'],
        jam: map['jam'],
        dateTime: datetime,
        isDone: map['isDone'] == 1);
  }
}
