import 'package:todo/model/model.dart';

class ToDo extends Model{
  static String table = "todotable";

  int id;
  String task;
  String tanggal;

  ToDo({this.id, this.task, this.tanggal});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'task': task, 'tanggal': tanggal};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(id: map['id'], task: map['task'], tanggal: map['tanggal']);
  }
}
