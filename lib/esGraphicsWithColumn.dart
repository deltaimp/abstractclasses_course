import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(FutureBuilderAppExample());

class FutureBuilderAppExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextFieldWithFuture(initialText: 'Waiting for server...'),
    );
  }
}

class TextFieldWithFuture extends StatefulWidget {
  final String initialText;

  const TextFieldWithFuture({super.key, required this.initialText});
  // text field with future ha in ingresso un initialText nel costruttore

  @override // da implementare per forza
  State<TextFieldWithFuture> createState() => _TextFieldWithFutureState();
}

class _TextFieldWithFutureState extends State<TextFieldWithFuture> {
  late Future<String> _futureString;
  late TextEditingController controller;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(controller: controller),
                  const SizedBox(height: 20),
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
                    snapshot.data!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Column( // colonna
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