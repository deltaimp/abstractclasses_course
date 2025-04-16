import 'package:flutter/material.dart';

void main() => runApp(const SingleChildScrollViewExampleApp());

class SingleChildScrollViewExampleApp extends StatelessWidget {
  const SingleChildScrollViewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SingleChildScrollViewExample());
  }
}

class SingleChildScrollViewExample extends StatelessWidget {
  const SingleChildScrollViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(553, 3, 55, 44),
      appBar: AppBar(title: const Text('Login Screen'), backgroundColor: Color.fromARGB(553, 3, 55, 44)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Immagine con placeholder
                  SizedBox(
                    height: 150,
                    child: Image.network(
                      'https://media.istockphoto.com/id/1408518230/it/foto/mare-sottomarino-abisso-dacqua-profonda-con-luce-blu-del-sole.jpg?s=2048x2048&w=is&k=20&c=QnKgAEA0iR0DZzGHyiYSf1jbtjgOwP_0zEu-SX0C0VE=',
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Accedi'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Registrati'),
                  ),
                  const SizedBox(height: 50), // Spazio finale
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}