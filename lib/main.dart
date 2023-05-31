import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BancoDigitalApp(),
    theme: ThemeData(
      hintColor: Colors.green,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  var url =
      Uri.parse('https://api.hgbrasil.com/finance?format=json&key=713b9db2');
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

class BancoDigitalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Digital',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(saldo: 10000),
        '/currency_conversion': (context) => MyHomePage(),
        '/transfer': (context) => TransferPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banco digital'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nome de Usuário',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Entrar'),
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                if (username == 'ygor' && password == '123456') {
                  Navigator.pushNamed(context, '/home');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erro de Login'),
                        content: Text('Nome de usuário ou senha inválidos.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final double saldo;

  HomePage({required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banco Digital'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Saldo: R\$ $saldo'),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Cotação'),
              onPressed: () {
                Navigator.pushNamed(context, '/currency_conversion');
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Transferência'),
              onPressed: () {
                Navigator.pushNamed(context, '/transfer');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransferPage extends StatefulWidget {
  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  TextEditingController _destinyAccountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  double saldo = 500;

  void transferir() {
    String destinyAccount = _destinyAccountController.text;
    double amount = double.parse(_amountController.text);

    if (destinyAccount.isNotEmpty && amount > 0 && amount <= saldo) {
      saldo -= amount;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Transferência realizada'),
            content: Text(
                'Transferência de R\$ $amount para a conta $destinyAccount concluída com sucesso.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro na transferência'),
            content:
                Text('Verifique os dados da transferência e tente novamente.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  compartilharMaionese() {
    SocialShare.share
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferência'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: compartilharMaionese,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _destinyAccountController,
              decoration: InputDecoration(
                labelText: 'Conta de Destino',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Valor',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Enviar'),
              onPressed: () {
                transferir();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar = 0.0;
  double euro = 0.0;

  VoidCallback? _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  VoidCallback? _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  VoidCallback? _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversor de moeda"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Aguarde...",
                  style: TextStyle(color: Colors.green, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                String? erro = snapshot.error.toString();
                return Center(
                  child: Text(
                    "Ops, houve uma falha ao buscar os dados: $erro",
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(Icons.attach_money,
                          size: 180.0, color: Colors.green),
                      campoTexto("Reais", "R\$", realController, _realChanged),
                      const Divider(),
                      campoTexto("Euros", "€", euroController, _euroChanged),
                      const Divider(),
                      campoTexto(
                          "Dólares", "US\$", dolarController, _dolarChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget campoTexto(
    String label, String prefix, TextEditingController c, Function? f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.green),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(color: Colors.green, fontSize: 25.0),
    onChanged: (value) {
      if (f != null) {
        f(value);
      }
    },
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
