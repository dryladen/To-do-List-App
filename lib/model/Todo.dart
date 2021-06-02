import 'package:todo/model/model.dart';

class ToDo extends Model{
  static String table = "todoTable";

  int id;
  String task;
  String tanggal;
  String jam;
  bool isDone;


  ToDo({this.id, this.task, this.tanggal, this.jam, this.isDone});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'task': task, 'tanggal': tanggal, 'jam': jam, 'isDone': isDone};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static ToDo fromMap(Map<dynamic, dynamic> map) {
    print(map);
    return ToDo(id: map['id'], task: map['task'].toString(), tanggal: map['tanggal'], jam: map['jam'], isDone: map['isDone'] == 1);
    
  }
}
