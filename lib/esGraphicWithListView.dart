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
  late TextInfoController textInfoController;
  late TextInfoController listElementNumbersController;
  late List<int> randomNumbers = [];

  @override
  void initState() {
    // inizializzazione risorse
    _futureInt = _getInitialValue();
    controller = TextEditingController();
    controller.text = widget.initialText;
    textInfoController = TextInfoController();
    listElementNumbersController = TextInfoController();

    _futureInt.then((v) =>
        WidgetsBinding.instance.addPostFrameCallback((_) {
          listElementNumbersController.changeNumber(v);
          setState(() {
            randomNumbers = generateNumbers(v);
          });
        })
    );
    super.initState();
  }

  @override
  void dispose() {
    /*  serve per uso delle risorse (liberare) */
    controller.dispose();
    textInfoController.dispose();
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
            ConnectionState.waiting => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: TextField(controller: controller)),
                const SizedBox(width: 20),
                const CircularProgressIndicator(),
              ],
            ),
            ConnectionState.active => const CircularProgressIndicator(),
            ConnectionState.done => _buildBody(snapshot.data!)
          };
        },
      ),
    );
  }
  
  Widget _buildBody(int nNumbersToGenerate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TextInfoWidget(
          labelToDisplay: 'Numero elementi lista:',
          controller: listElementNumbersController,
          bkColor: Colors.orange,
        ),
        _TextInfoWidget(
          bkColor: Colors.yellow,
          labelToDisplay: 'Numero selezionato:',
          controller: textInfoController,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: randomNumbers.length,
            itemBuilder:
                (context, index) => ListTile(
              title: Text(
                randomNumbers[index].toString(),
                style: const TextStyle(fontSize: 20),
              ),
              onTap: () {
                textInfoController.changeNumber(randomNumbers[index]);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Premuto: ${randomNumbers[index]}",
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              tileColor: Colors.orangeAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _TextInfoWidget extends StatefulWidget {
  final TextInfoController? controller;
  final String labelToDisplay;
  final Color bkColor;
  final int Function()? onNewSelectedNumber;

  const _TextInfoWidget({
    super.key,
    this.controller,
    required this.labelToDisplay,
    this.onNewSelectedNumber,
    this.bkColor = Colors.white
  });

  @override
  State<_TextInfoWidget> createState() => _TextInfoWidgetState();
}

class _TextInfoWidgetState extends State<_TextInfoWidget> {

  @override
  void initState() {
    widget.controller?.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: widget.bkColor,
          child: Text(
            '${widget.labelToDisplay} ${widget.controller?.numberSelected ?? 'nessuno'}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class TextInfoController extends ChangeNotifier {
  int? _numberSelected;
  int? get numberSelected => _numberSelected;

  TextInfoController({int? numberSelected}) : _numberSelected = numberSelected;
  changeNumber(int? numberSelected) {
    _numberSelected = numberSelected;
    notifyListeners();
  }
}
