import 'package:flutter/material.dart';

import 'constants.dart';
import 'logic.dart';
import 'widgets/keypad.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String txtResult = '0';

  final Logic _logic = Logic();

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_declare_return_types
    onPressed(String text) {
      _logic.input(text);
      setState(() => txtResult = _logic.text);
    }

    return Scaffold(
      backgroundColor: colorMain,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      txtResult,
                      key: const Key('txtResult'),
                      style: const TextStyle(color: colorText, fontSize: 60),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
              KeyPad(onPressed),
            ],
          ),
        ),
      ),
    );
  }
}
