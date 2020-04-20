import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _information = "Digite seus dados";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetdata(){
    setState(() {
      weightController.text = "";
      heightController.text = "";
      _information = "Digite seus dados";
      _formKey = GlobalKey<FormState>();
    });
  }
  void _calculateIMC(){
    double IMC = 0.0;
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);


    IMC = weight/(height*height);
    print(IMC);
    setState(() {
      if(IMC<18.6){
        _information = "Seu IMC é "+IMC.toStringAsPrecision(4)+".\nVocê está abaixo do peso ideal!";
      }else if(IMC>=18.6 && IMC<24.9){
        _information = "Seu IMC é "+IMC.toStringAsPrecision(4)+".\nVocê está no peso ideal!";
      }else if(IMC>=24.9 && IMC<34.9){
        _information = "Seu IMC é "+IMC.toStringAsPrecision(4)+".\nObesidade de grau I";
      }else if(IMC>=34.9 && IMC<39.9){
        _information = "Seu IMC é "+IMC.toStringAsPrecision(4)+".\nObesidade de grau II";
      }else if(IMC>39.9){
        _information = "Seu IMC é "+IMC.toStringAsPrecision(4)+".\nObesidade de grau III";
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora IMC", style: TextStyle(fontSize: 22.0)),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: () {_resetdata();})
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.accessibility,
                  color: Colors.green,
                  size: 120.0,
                ),
                TextFormField(controller: weightController,
                  validator: (value){
                    if(value.isEmpty){
                      return "Insira seu peso";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.green,fontSize: 25),
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.green)
                  ),
                ),
                TextFormField( controller: heightController,
                  validator: (value){
                      if(value.isEmpty){
                        return "Insira sua altura";
                      }
                      return null;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.green,fontSize: 25),
                  decoration: InputDecoration(
                      labelText: "Altura (m)",
                      labelStyle: TextStyle(color: Colors.green)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 10.0),
                  child:  Container(
                      height: 50.0,
                      child:RaisedButton(
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            _calculateIMC();
                            print("teste");
                          }
                          print("teste2");
                          },
                        child: Text("Calcular",style: TextStyle(color: Colors.white,fontSize: 25.0),),
                        color: Colors.green,
                      )

                  ),
                ),
                Text("$_information", style: TextStyle(color: Colors.green,fontSize: 20.0),textAlign: TextAlign.center,)
              ],
            ),
          )
        )
    );
  }
}
