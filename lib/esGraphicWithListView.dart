import 'dart:math';
import 'package:flutter/material.dart';

/*punto di partenza dell'applicazione*/
void main() => runApp(FutureBuilderAppExample());


/*
* configura il MaterialApp e imposta TextFieldWithFuture
* */
class FutureBuilderAppExample extends StatelessWidget {
  const FutureBuilderAppExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextFieldWithFuture(initialText: 'Waiting for server...'),
    );
  } // build
}

/*
* TextFieldWithFuture deve gestire lo stato:
* ha un Future che ottiene un valore iniziale,
* un TextEditingController,
* e una lista di numeri casuali.
* Questi elementi cambiano nel tempo
* quindi necessitano di essere mantenuti nello stato del widget.
* */
class TextFieldWithFuture extends StatefulWidget {
  final String initialText;

  const TextFieldWithFuture({super.key, required this.initialText});

  @override
  State<TextFieldWithFuture> createState() => _TextFieldWithFutureState();
}

class _TextFieldWithFutureState extends State<TextFieldWithFuture> {
  late Future<int> _futureInt;
  late TextEditingController controller;
  late List<int> randomNumbers = [];

  @override
  void initState() { // inizializzazione risorse
    _futureInt = _getInitialValue();
    controller = TextEditingController();
    controller.text = widget.initialText;
    super.initState();

    _futureInt.then((value) { /* quando ha il future inizializza la lista di numeri */
      setState(() {
        randomNumbers = generateNumbers(value); /* ogni volta genera un numero casuale di numeri casuali */
      });
    });
  }

  @override
  void dispose() { /*  serve per uso delle risorse (liberare) */
    controller.dispose();
    super.dispose();
  }

  List<int> generateNumbers(int howManyNumbers) {
    return List.generate(howManyNumbers, (_) => Random().nextInt(500));
  }

  Future<int> _getInitialValue() {
    return Future.delayed(
      Duration(seconds: 2),
    ).then((_) => Random().nextInt(400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Esempio numeri random con list view')),
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
            ConnectionState.done => Column(
              children: [
                Text(
                  '   Numero estratto: ${snapshot.data}   ',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.orange
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: randomNumbers.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        randomNumbers[index].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Premuto: ${randomNumbers[index]}"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      tileColor: Colors.orangeAccent,
                    ),
                  ),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
