import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    var resultText = 'You\'re a promising programmer.';
    if (resultScore >= 45) {
      resultText = 'You\'re an excellent programmer.';
    } else if (resultScore >= 25) {
      resultText = 'You\'re a solid programmer.';
    }

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
      Text(
        resultPhrase,
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      FlatButton(
        onPressed: resetHandler,
        child: Text('Reset quiz here.'),
        textColor: Colors.blueGrey,
      )
    ]));
  }
}
