import 'package:flutter/material.dart';
import 'package:todo_app/database/db.dart';
import 'package:todo_app/database/model.dart';
import 'package:google_fonts/google_fonts.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoAttributes> _todo = [];
  List<Widget> get _items => _todo.map((item)=> format(item)).toList();
  String? _workname;
  int? _workid;
  Widget format(ToDoAttributes items){
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10,5),
      child: Dismissible(
        key: Key(items.id.toString()),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
            color: Colors.blueGrey,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0.0,10.0),
              ),
            ]
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    items.name.toString(),
                  style: GoogleFonts.poppins(fontSize: 15,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        onDismissed: (DismissDirection d){
          Db.delete(ToDoAttributes.table, items);
          reload();
        },
      ),
    );
  }
  void _createWork(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Please Add your works"),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Work name",
                    ),
                    onChanged: (name){_workname = name;},
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: ()=>_savework(),
                  child: Text("Save your work"),
              ),
            ],
          );
        }
    );
  }
  void _savework() async{
    Navigator.of(context).pop();
    ToDoAttributes item = ToDoAttributes(
        id: _workid,
        name: _workname
    );
    await Db.insert(ToDoAttributes.table,item);
    setState(() {});
    reload();
  }
  @override
  void initState() {
    // TODO: implement initState
    reload();
    super.initState();
  }
  void reload() async{
    List<Map<String,dynamic>> _result = await Db.query(ToDoAttributes.table);
    _todo = _result.map((item)=> ToDoAttributes.fromMap(item)).toList();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25,25,0,10),
              child: Text(
                  "Todo App",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 25,color: Colors.black),
              ),
            ),
            ListView(
              children: _items,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _createWork(context),
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.black26,
        elevation: 0,
      ),

    );
  }

}

