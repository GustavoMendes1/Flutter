import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

const key = '48d4d856'; //necessário criar no HG finance
const request = 'https://api.hgbrasil.com/finance/quotations?key=$key';
double dolar_Api;
double euro_Api;
double real;

final realController = TextEditingController();
final dolarController = TextEditingController();
final euroController = TextEditingController();

void main() async{
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return jsonDecode(response.body)["results"]["currencies"];
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text("Conversor de moedas",textAlign: TextAlign.center, style: TextStyle(fontSize:23),),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        // ignore: missing_return
        builder: (context,snapshote){
          switch(snapshote.connectionState){
            case ConnectionState.none:
              return(Center(
                  child:Text("Problema ao carregar dados.",style:TextStyle(color: Colors.black,fontSize: 25.0),)
              ));
              break;
            case ConnectionState.waiting:
            case ConnectionState.active:
              return(Center(
                  child:Text("Carregando dados",style:TextStyle(color: Colors.black,fontSize: 25.0),)
              ));
              break;
            case ConnectionState.done:
                if(snapshote.hasError){
                  return Center(
                      child:Text("Erro ao carregar dados",style:TextStyle(color: Colors.black,fontSize: 25.0),)
                  );
                }else{
                  initialisemoney(snapshote);

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        buildTextField("Real", "R\$ ", 0.0,realController,_realChanged),
                        buildTextField("Dolar", "\$ ", 10.0,dolarController,_dolarChanged),
                        buildTextField("Euro", "€ ", 10.0,euroController,_euroChanged),

                      ],
                    ),
                  );
                }
              break;
          }
        },
      ),
    );
  }
}

void initialisemoney(AsyncSnapshot<Map> snapshote) {
  dolar_Api = snapshote.data["USD"]["buy"];
  euro_Api = snapshote.data["EUR"]["buy"];
}
Widget buildTextField(String label, String prefix, double top,TextEditingController controller, Function function){
  return Padding(
      padding: EdgeInsets.only(top:top),
      child:TextField(
        onChanged: function,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "$label",
            labelStyle: TextStyle(color: Colors.black38),
            border: OutlineInputBorder(),
            prefixText: "$prefix"
        ),
      ));
}

void _realChanged(String text){
  if(text.isEmpty){
    _clearAll();
  }else {
    real = double.parse(text);

    dolarController.text = (real / dolar_Api).toStringAsPrecision(4);
    euroController.text = (real / euro_Api).toStringAsPrecision(4);
  }
}
void _dolarChanged(String text){
  if(text.isEmpty){
    _clearAll();
  }else {
    double dolar = double.parse(text);

    realController.text = (dolar*dolar_Api).toStringAsPrecision(4);
    euroController.text = ((dolar*dolar_Api)/euro_Api).toStringAsPrecision(4);
  }
}
void _euroChanged(String text){

  if(text.isEmpty){
    _clearAll();
  }else {
    double euro = double.parse(text);
    realController.text = (euro * euro_Api).toStringAsPrecision(4);
    dolarController.text = ((euro * euro_Api) / dolar_Api).toStringAsPrecision(4);
  }
}

void _clearAll(){
  realController.text = "";
  dolarController.text = "";
  euroController.text = "";
}
