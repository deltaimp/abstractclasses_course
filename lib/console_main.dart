//import 'package:flutter/material.dart';

import 'dart:io';



abstract class CanRun {
  // void runUnimplementedSoAbstractMethod(); // abstract (empty) method (no implementation)
  // no logic in run() method
// hello
  void run();

// you can also write code here --> not abstract method
// normal function

// no parameter, no return value
// any class that will extends this, will have to implement this run
}

class Cat extends CanRun {
  @override // meta tag --> this run function is overriding
  void run() {

    print("CanRun's run function is called");
  }
  void walk(){
    print("walks!");
  }
// : implement runUnimplementedSoAbstractMethod
// alt+0 apre finestra commit
// will inheritance from that, posso ereditare solo da uno
// con with posso portare classes senza limiti
// devo implementare run()
// sto estendendo CanRun


//ciaoooo

}

void main() {
  final cat = Cat();
  print("ciao");
  cat.run();  // Stampa: "CanRun's run function is called"
  cat.walk(); // Stampa: "walks!!
}

