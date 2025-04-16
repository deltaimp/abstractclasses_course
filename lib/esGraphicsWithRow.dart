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
  final String initialText; // testo iniziale passato al costruttore

  const TextFieldWithFuture({super.key, required this.initialText});
  // key = identificatore del widget nell'albero, serve per performance
  // initial text required serve per obbligare a passare un testo iniziale

  @override // da implementare per forza
  // crea lo stato associatoal widget
  State<TextFieldWithFuture> createState() => _TextFieldWithFutureState();
}

class _TextFieldWithFutureState extends State<TextFieldWithFuture> {
  late Future<String> _futureString; // future per operazione asincrona
  late TextEditingController controller; // controller per il textfield
  late List<int> randomNumbers;

  @override
  void initState() {
    _futureString = _getInitialValue();
    controller = TextEditingController();
    controller.text = widget.initialText;
    randomNumbers = generateNumbers(100); // Genera 100 numeri random
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<int> generateNumbers(int howManyNumbers) {
    return List.generate(howManyNumbers, (_) => Random().nextInt(500));
  }

  Future<String> _getInitialValue() {
    return Future.delayed(Duration(seconds: 2))
        .then((_) => "Numero estratto ${Random().nextInt(200)}!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Esempio Numeri Random')),
      body: FutureBuilder<String>(
        future: _futureString,
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
              child: Row(
                mainAxisSize: MainAxisSize.min, // si restringe intorno a contenuto
                children: [
                  Text(
                    snapshot.data!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: randomNumbers // con i randomNumbers
                        .map((number) => Text(  // e rende testo ogni numero generato
                      number.toString(),
                      style: const TextStyle(fontSize: 20),
                    ))
                        .toList(),
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