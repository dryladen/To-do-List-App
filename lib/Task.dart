class Task {
  int id;
  String todo;
  String tanggal;

  Task({this.id, this.todo, this.tanggal});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'todo': todo, 'tanggal': tanggal};
    return map;
  }

  Task.fromMap(Map<String, dynamic> map){
    id = map['id'];
    todo = map['todo'];
    tanggal = map['tanggal'];
  }
}
