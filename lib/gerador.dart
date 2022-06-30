import 'package:flutter/material.dart';
import 'package:trotter/trotter.dart';

class MyGerador extends StatefulWidget {
  final String title;
  final List<int> numbersEscolhidos;
  final int numbersCombinacoes;

  const MyGerador({Key? key, required this.title, required this.numbersEscolhidos, required this.numbersCombinacoes}) : super(key: key);

  @override
  State<MyGerador> createState() => _MyGeradorState(this.numbersEscolhidos, this.numbersCombinacoes);
}

class _MyGeradorState extends State<MyGerador> {
  int _counter = 0;

  _MyGeradorState(numbersEscolhidos, numbersCombinacoes);

  List<int> numbersLinhas = [for (var i = 1; i <= 10; i++) i];
  List<int> numbersColunas = [for (var i = 1; i <= 100; i++) i];
  get numbersEscolhidos => null;
  int _numbersLimit = 60;
  int _numbersCombinacoes = 5;


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

    _gerados = lista.length == 0
        ? Container()
        : Container(
      child: Expanded(
        child: ListView.builder(
          // outer ListView
          itemCount: lista.length,
          shrinkWrap: true, // 1st add
          physics: ClampingScrollPhysics(), // 2nd add
          itemBuilder: (_, index) {
            var tested = lista[index];
            return //Container();
              Row(
                children: tested.map<Widget>((item) {
                  print(item);
                  print("asdf");
                  return ClipOval(
                    child: Container(
                      color: Colors.blue,
                      child: SizedBox(
                          width: 50,
                          height: 40,
                          child: Center(
                            child: ActionChip(
                              label: Text(item.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              backgroundColor: Colors.blue,
                              onPressed: () {},
                            ),
                          )),
                    ),
                  );
                }).toList(),
              );
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    GetCombinacao();

    return _gerados;
  }

}