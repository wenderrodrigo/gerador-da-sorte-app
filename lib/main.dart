import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
//import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trotter/trotter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador da Sorte',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Gerador da sorte'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<int> numbersLinhas = [for (var i = 1; i <= 14; i++) i];
  List<int> numbersColunas = [for (var i = 1; i <= 100; i++) i];
  List<int> numbersEscolhidos = [];
  List<int> numbersTeste = [];
  int _numbersLimit = 60;
  int _numbersCombinacoes = 5;
  int _jogosGerados = 0;

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();


  var _gerados = Container();

  GetCombinacao() {
    final _teste = numbersEscolhidos.map((i) => i.toString()).join(",");

    var lista = [];

    if (_numbersCombinacoes < _teste.split(',').length) {
      final bagOfItems = _teste.split(','),
          combos = Combinations(_numbersCombinacoes, bagOfItems);
      for (final combo in combos()) {
        lista.add(combo);
      }
    }
    _jogosGerados = lista.length;

    setState((){
      _btnController.stop();
    });

    _gerados = lista.length == 0
        ? Container()
        : Container(
      //height: (_jogosGerados * 70),
            margin: EdgeInsets.only(top: 50.0),
            child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
    //controller: ModalScrollController.of(context),
    child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // outer ListView
              itemCount: lista.length,
              itemBuilder: (_, index) {
                var tested = lista[index];
                return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: tested.map<Widget>((item) {
                            return Container(
                              alignment: Alignment.center,
                              width: 40,
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.green,
                                child: Text(item.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    )),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.0,
                                ),
                              ),
                            );
                          }).toList(),
                        ));
              },
            ),
            ),
          );
  }

  void _configurandoModalBottomSheet(context) {

    showModalBottomSheet(
      context: context,
      builder: (context) => GestureDetector(
          child: new Container(
            color: Colors.grey[800],
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0)),
              ),
              child: Stack(children: <Widget>[
                Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(right: 50.0, left: 50.0),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.green),
                      )),
                  child: Center(
                    child: Text(
                      'NUMEROS GERADOS (' + _jogosGerados.toString() + ' COMBINAÇÕES)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                _gerados,
              ]),

          ),
        ),
      ),
    );
  }

  void _errorModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => new Container(
            color: Colors.grey[800],
            height: 50,
            child: Stack(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 50.0, left: 50.0),
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0)),
                  color: Colors.redAccent),
                  child: Center(
                    child: Text(
                      'SELECIONE UMA QUANTIDADE MAIOR DE NUMEROS QUE O SELECIONADO NO CAMPO "Dezenas"',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ]),
      ),
    );

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final bagOfItems = characters('abcde'),

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              child: Row(
                children: [
                  SizedBox(width: 30.0),
                  Text("Dezenas:"),
                  SizedBox(width: 12.0),
                  DropdownButton<int>(
                    value: _numbersCombinacoes,
                    items:
                        <int>[for (var i = 5; i <= 60; i++) i].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _numbersCombinacoes = int.parse(value.toString());
                      });
                    },
                  ),
                  SizedBox(width: 30.0),
                  Text("Numeros na cartela:"),
                  SizedBox(width: 12.0),
                  DropdownButton<int>(
                    value: _numbersLimit,
                    items: <int>[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                        .map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _numbersLimit = int.parse(value.toString());
                        numbersEscolhidos.removeWhere((element) => element > _numbersLimit);
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: numbersLinhas.map((itemLinha) {
                      return Row(
                        children: numbersColunas
                            .where((element) =>
                                ((itemLinha == 1 &&
                                        element >= 0 &&
                                        element <= 7) ||
                                    (itemLinha == 2 &&
                                        element >= 8 &&
                                        element <= 14) ||
                                    (itemLinha == 3 &&
                                        element >= 15 &&
                                        element <= 21) ||
                                    (itemLinha == 4 &&
                                        element >= 22 &&
                                        element <= 28) ||
                                    (itemLinha == 5 &&
                                        element >= 29 &&
                                        element <= 35) ||
                                    (itemLinha == 6 &&
                                        element >= 36 &&
                                        element <= 42) ||
                                    (itemLinha == 7 &&
                                        element >= 43 &&
                                        element <= 49) ||
                                    (itemLinha == 8 &&
                                        element >= 50 &&
                                        element <= 56) ||
                                    (itemLinha == 9 &&
                                        element >= 57 &&
                                        element <= 63) ||
                                    (itemLinha == 10 &&
                                        element >= 64 &&
                                        element <= 70) ||
                                    (itemLinha == 11 &&
                                        element >= 71 &&
                                        element <= 77) ||
                                    (itemLinha == 12 &&
                                        element >= 78 &&
                                        element <= 84) ||
                                    (itemLinha == 13 &&
                                        element >= 85 &&
                                        element <= 91) ||
                                    (itemLinha == 14 &&
                                        element >= 92 &&
                                        element <= 98) ||
                                    (itemLinha == 15 &&
                                        element >= 99 &&
                                        element <= 107)) &&
                                element <= _numbersLimit)
                            .map((item) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                if (!numbersEscolhidos.contains(item)) {
                                  numbersEscolhidos.add(item);
                                  numbersEscolhidos.sort();
                                } else {
                                  numbersEscolhidos.remove(item);
                                  numbersEscolhidos.sort();
                                }

                                if (_numbersCombinacoes <
                                    numbersEscolhidos
                                        .map((i) => i.toString())
                                        .join(",")
                                        .split(',')
                                        .length) {
                                  GetCombinacao();
                                }
                              });
                            },
                            iconSize: 30.8,
                            icon: Container(
                              width: 100,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor:
                                    numbersEscolhidos.contains(item)
                                        ? Colors.green
                                        : Colors.white,
                                child: Text(item.toString(),
                                    style: TextStyle(
                                      color: numbersEscolhidos.contains(item)
                                          ? Colors.white
                                          : Colors.blue,
                                      fontSize: 12.0,
                                    )),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: () {},
                child: RoundedLoadingButton(
                    child: Text("Gerar"),
                  controller: _btnController,
                  onPressed: (){
                    if (_numbersCombinacoes <
                        numbersEscolhidos
                            .map((i) => i.toString())
                            .join(",")
                            .split(',')
                            .length) {
                      setState((){
                        _btnController.reset();
                      });
                      _configurandoModalBottomSheet(context);
                    }else{
                      setState((){
                        _btnController.reset();
                      });

                      _errorModalBottomSheet(context);
                    }
                  },
                ),
            ),
          ]),
        ),
        // ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: numbers.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return numbers[index] == null || index >= 10
        //           ? Container()
        //           : Wrap(
        //           runSpacing: 8,
        //           spacing: 8,
        //           children: [ActionChip(
        //             label: Text(numbers[index].toString()),
        //             labelStyle: TextStyle(
        //                 fontWeight: FontWeight.bold, color: Colors.white),
        //             backgroundColor: Colors.green,
        //             onPressed: () => print("Perform some action here"),
        //           )]
        //       );
        //     }),

        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Text(
        //       'You have pushed the button this many times:',
        //     ),
        //     Text(
        //       '$_counter',
        //       style: Theme.of(context).textTheme.headline4,
        //     ),
        //   ],
        // ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
