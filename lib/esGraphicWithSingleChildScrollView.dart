import 'dart:math'; // per generare numeri random
import 'package:flutter/material.dart';

// punto di ingresso dell'app
void main() => runApp(FutureBuilderAppExample());

class FutureBuilderAppExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextFieldWithFuture(initialText: 'Waiting for server...'), // pagina iniziale
    );
  }
}

class TextFieldWithFuture extends StatefulWidget {
  final String initialText; // testo iniziale passato dal costruttore

  const TextFieldWithFuture({super.key, required this.initialText});
  // key = identificatore del widget nell'albero, serve per performance
  // initial text required serve per obbligare a passare un testo iniziale

  @override // da implementare per forza
  // crea lo stato associatoal widget
  State<TextFieldWithFuture> createState() => _TextFieldWithFutureState();
}

class _TextFieldWithFutureState extends State<TextFieldWithFuture> {
  late Future<int> _futureInt; // future per operazione asincrona
  late TextEditingController controller; // controller per il textfield
  late List<int> randomNumbers;

  @override
  void initState() {
    //_futureString = _getInitialValue();
    _futureInt = _getInitialValue();
    controller = TextEditingController();
    controller.text = widget.initialText;

    super.initState();

    _futureInt.then((extractedValue) {
      setState(() {
        randomNumbers= generateNumbers(extractedValue);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<int> generateNumbers(int howManyNumbers) {
    return List.generate(howManyNumbers, (_) => Random().nextInt(500));
  }

  Future<int> _getInitialValue() {
    return Future.delayed(Duration(seconds: 2))
        .then((_) => Random().nextInt(200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Esempio Numeri Random')),
      body: FutureBuilder<int>(
        future: _futureInt,
        builder: (context, snapshot) {
          return switch (snapshot.connectionState) {
            ConnectionState.none => const SizedBox.shrink(),
            ConnectionState.waiting => Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(controller: controller),
                  const SizedBox(width: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
            ConnectionState.active => const CircularProgressIndicator(),
            ConnectionState.done => Center( // quando è pronto
              child: Column( // mostra una colonna
                mainAxisSize: MainAxisSize.min, // si restringe intorno a contenuto
                children: [
                  Text(
                    snapshot.data.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox( // colonna
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: randomNumbers.map((number) => Text (
                          number.toString(),
                          style: const TextStyle(fontSize: 20),
                        ))
                        .toList(),
                      )
                    )
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}