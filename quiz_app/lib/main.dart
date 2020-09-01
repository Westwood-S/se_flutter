import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Programmer Quiz!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _questions = const [
    {
      'questionText': 'Which programming language do you prefer?',
      'answers': [
        {'text': 'Python', 'score': 5},
        {'text': 'JavaScript', 'score': 10},
        {'text': 'C/C++', 'score': 15},
        {'text': 'Java', 'score': 1},
      ],
    },
    {
      'questionText': 'What\'s your fav operating system?',
      'answers': [
        {'text': 'Windows', 'score': 1},
        {'text': 'MacOS', 'score': 15},
        {'text': 'Linux', 'score': 10},
        {'text': 'Others', 'score': 5},
      ],
    },
    {
      'questionText': 'What\'s your GPA? (out of 4)',
      'answers': [
        {'text': '>3.9', 'score': 15},
        {'text': '>3', 'score': 10},
        {'text': '2-3', 'score': 5},
        {'text': '<2', 'score': 1},
      ],
    },
    {
      'questionText': 'How many internships have you had?',
      'answers': [
        {'text': '0', 'score': 1},
        {'text': '1-2', 'score': 5},
        {'text': '3-4', 'score': 10},
        {'text': '>4', 'score': 15},
      ],
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answersQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answersQuestion,
                questions: _questions,
                questionIndex: _questionIndex,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
// Invoke "debug painting" (press "p" in the console, choose the
// "Toggle Debug Paint" action from the Flutter Inspector in Android
// Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
// to see the wireframe for each widget.
//
// Column has various properties to control how it sizes itself and
// how it positions its children. Here we use mainAxisAlignment to
// center the children vertically; the main axis here is the vertical
// axis because Columns are vertical (the cross axis would be
// horizontal).
