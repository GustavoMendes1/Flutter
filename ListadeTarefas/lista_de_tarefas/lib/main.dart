import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _taskController = TextEditingController();
  List _list = [];
  Map<String, dynamic> _LastRemove = Map();
  int positionLastRemove;

  @override
  void initState() {
    super.initState();
    _readData().then((data){
      setState(() {
        _list = json.decode(data);
      });

    }
    );
  }

  void addTask(){
    setState(() {
      Map<String, dynamic> NewTask = Map();
      NewTask["title"] = _taskController.text;
      NewTask["ok"] = false;
      _list.add(NewTask);
      _taskController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 1, 10, 1),
              child: Row(
                children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _taskController,
                  decoration: InputDecoration(
                      labelText: "Nova tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                  ),
                ),),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: (){addTask();},
                )
              ],
            )
          ),
          Expanded(
            child: RefreshIndicator( onRefresh: _refrashData,
              child: ListView.builder(
                  padding: EdgeInsets.only(top:10),
                  itemCount: _list.length,
                  itemBuilder:BuildIcon ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildIcon(context,index){

    return Dismissible( //permite arrastar o item para deleta-lo
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color:Colors.red,
        child:Align(
         alignment: Alignment(-0.9,0),
         child:Icon(Icons.delete,color: Colors.white,)
      )
      ),
      direction: DismissDirection.startToEnd,
      child:CheckboxListTile(
        title: Text(_list[index]["title"]),
        value: _list[index]["ok"],
        onChanged: (check){
          setState(() {
            _list[index]["ok"] = check;
            _saveData();
          });
        },
        secondary: CircleAvatar(
          backgroundColor:_list[index]["ok"] ? Colors.blueAccent : Colors.red ,
          child: Icon(_list[index]["ok"] ? Icons.check : Icons.error_outline,color: Colors.white,),
        ),

      ),
      onDismissed: (direction){
        setState(() {
          _LastRemove = Map.from(_list[index]);
          positionLastRemove = index;
          _list.removeAt(index);
          _saveData();
          final snack = SnackBar(
            duration: Duration(seconds: 3),
            content: Text("O item ${_LastRemove["title"]} foi removido!"),
            action: SnackBarAction(label: "Desfazer",
              onPressed: (){
              setState(() {
                _list.insert(positionLastRemove, _LastRemove);
                _saveData();
                });
              }),
          );
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );

  }

  Future<File> _getFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File("${dir.path}/data.json");
  }

  Future<File> _saveData() async{
    String data = json.encode(_list);
    final file = await _getFile();
    return file.writeAsString(data);
  }
  Future<String> _readData() async{
    try{
      final file = await _getFile();
      return file.readAsString();
    }catch(e){
      print(e);
      return null;
    }

  }
  Future<Null> _refrashData() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _list.sort((item1,item2){
        if(item1["ok"] && !item2["ok"]){
          return 1;
        }else if(!item1["ok"] && item2["ok"]){
          return -1;
        }else{
          return 0;
        }
    });
      _saveData();
    });
    return null;
  }

}


