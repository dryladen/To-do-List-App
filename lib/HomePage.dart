import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int jumlahItems = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("To-do List App")),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: ListView.builder(
        itemCount: jumlahItems,
        itemBuilder: (BuildContext context, int index) {
          return Items();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            jumlahItems++;
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Items extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        title: Text("IPAN"),
        tileColor: Colors.cyan[200],
        subtitle: Text("anjae"),
        trailing: Checkbox(
          value: true,
          onChanged: (value) {
            value = true;
          },
          activeColor: Colors.red,
        ),
      ),
    );
  }
}
