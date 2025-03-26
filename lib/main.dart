//import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;
import 'dart:io';

extension Log on Object {
  void log() => devtools.log(toString());
}


abstract class CanRun {
 // void runUnimplementedSoAbstractMethod(); // abstract (empty) method (no implementation)
  // no logic in run() method

 void run();

   // you can also write code here --> not abstract method
  // normal function

  // no parameter, no return value
// any class that will extends this, will have to implement this run
}

class Cat extends CanRun {
  @override // meta tag --> this run function is overriding
  void run() {

    "CanRun's run function is called".log();
  }
  void walk(){
    "walks!!".log();
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
  cat.run();  // Stampa: "CanRun's run function is called"
  cat.walk(); // Stampa: "walks!!
}

