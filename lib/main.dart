import 'package:flutter/material.dart';

class Pessoa {
  String result;
  String resulta;
  String resultadof = "";
  double resultado;

  int sexo;
  double peso, altura;
  Color color = Colors.black;

  Pessoa({this.sexo, this.peso, this.altura, this.result, this.resultado});

  calcularImc() {
    double calcimc;

    calcimc = this.peso / (this.altura * this.altura);
    resultado = calcimc;

    return calcimc;
  }



  void classFem() {
    result = "";
    if (resultado < 19.1) {
      result += "Abaixo do peso";
      color = Colors.blueAccent;
    } else if (resultado < 25.8) {
      result += "Peso ideal";
      color = Colors.greenAccent;
    } else if (resultado < 27.3) {
      result += "Levemente acima do peso";
      color = Colors.orangeAccent;
    } else if (resultado < 32.3) {
      result += "Acima do peso";
      color = Colors.brown;
    } else if (resultado > 32.3) {
      result += "Obesidade";
      color = Colors.redAccent;
    }
    resultadof = "IMC = ${resultado.toStringAsPrecision(4)}";
  }

  classMasc() {
    result = "";
    if (resultado < 20.7) {
      result += "Abaixo do peso";
      color = Colors.blueAccent;
    } else if (resultado < 26.4) {
      result += "Peso ideal";
      color = Colors.greenAccent;
    } else if (resultado < 27.8) {
      result += "Levemente acima do peso";
      color = Colors.orangeAccent;
    } else if (resultado < 31.1) {
      result += "Acima do peso";
      color = Colors.brown;
    } else if (resultado > 31.1) {
      result += "Obesidade";
      color = Colors.redAccent;
    }
    resultadof = "IMC = ${resultado.toStringAsPrecision(4)}";
  }

  String classificar({double imc}) {
    if (imc < 18.5)
      return "Abaixo do peso";
    else if (imc < 25.0)
      return "Peso normal";
    else if (imc < 30.0)
      return "Sobrepeso";
    else if (imc < 35.0)
      return "Obesidade grau 1";
    else if (imc < 40.0)
      return "Obesidade grau 2";
    else
      return "Obesidade grau 3";
  }
}

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.purple),
        
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  Pessoa _pessoa = Pessoa();

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    _handleRadioValueChange(-1);
    setState(() {
      _pessoa.result = 'Informe seus dados';
      _pessoa.resultadof = "";
      _pessoa.color = Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Center(
        child: Text('Calculadora de IMC'),
      ),
      backgroundColor: Colors.purple,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            buttonClear(context);
          },
        )
      ],
    );
  }

  void calculateImc() {
    _pessoa.peso = double.parse(_weightController.text);
    _pessoa.altura = double.parse(_heightController.text) / 100.0;

    _pessoa.resultado = _pessoa.calcularImc();

    setState(() {
      if (_resulta == 1) {
        _pessoa.classMasc();
      } else if (_resulta == 2) {
        _pessoa.classFem();
      } else {
        msgErro(context);
      }
    });
  }


  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          sexButton(),
          buildTextFormField(
              label: "Peso (Kg)",
              error: "Insira seu peso!",
              controller: _weightController),
          buildTextFormField(
              label: "Altura (cm)",
              error: "Insira uma altura!",
              controller: _heightController),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  // state variable
  int _resulta = 0;
  int _radioValue;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _resulta = 1;
          break;
        case 1:
          _resulta = 2;
          break;
      }
    });
  }

  void msgErro(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("ERRO", style: TextStyle(color: Colors.purple)),
          content: new Text("Selecione o Gênero."),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              textColor: Colors.purple,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  buttonClear(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("NÃO"),
      textColor: Colors.purple,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("SIM"),
      textColor: Colors.purple,
      onPressed: () {
        _resulta = 0;
        resetFields();
        Navigator.of(context).pop();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("APAGAR", style: TextStyle(color: Colors.purple)),
      content: Text("DESEJA APAGAR AS INFORMAÇÕES"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Widget sexButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.01),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Radio(
              activeColor: Colors.purple,
              value: 0,
              groupValue: _radioValue,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              'Masculino',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
            new Radio(
              activeColor: Colors.purple,
              value: 1,
              groupValue: _radioValue,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              'Feminino',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ]),
    );
  }

  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            _pessoa.resultadof,
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.5),
          ),
          new Text(
            _pessoa.result,
            style: TextStyle(
              color: _pessoa.color,
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }


  Widget buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            calculateImc();
          }
        },
        child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
        color: Colors.purple,
      ),
    );
  }


  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}
