import 'package:calculator/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '';
  final myTextstyle = TextStyle(fontSize: 30, color: Colors.deepPurple[900]);

  // declaring the keypads
  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userQuestion,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.centerRight,
                        child: Text(
                          userAnswer,
                          style: TextStyle(fontSize: 30),
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: GridView.builder(
                    itemCount: buttons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      // clear button
                      if (index == 0) {
                        return MyButtons(
                          buttonTapped: () {
                            setState(() {
                              userQuestion = '';
                              userAnswer = '';
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.green,
                          textcolor: Colors.white,
                        );
                      }

                      // delete button
                      else if (index == 1) {
                        return MyButtons(
                          buttonTapped: () {
                            setState(() {
                              userQuestion = userQuestion.substring(
                                  0, userQuestion.length - 1);
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.red,
                          textcolor: Colors.white,
                        );
                      }

                      //Ans button
                      else if (index == buttons.length - 2) {
                        return MyButtons(
                          buttonTapped: () {
                            setState(() {
                              userQuestion = userAnswer;
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.deepPurple[50],
                          textcolor: Colors.deepPurple,
                        );
                      }

                      // equal to button
                      else if (index == buttons.length - 1) {
                        return MyButtons(
                          buttonTapped: () {
                            setState(() {
                              equalPressed();
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.deepPurple,
                          textcolor: Colors.white,
                        );
                      }

                      // operational buttons
                      else {
                        return MyButtons(
                          buttonTapped: () {
                            setState(() {
                              userQuestion += buttons[index];
                            });
                          },
                          buttonText: buttons[index],
                          color: isOparator(buttons[index])
                              ? Colors.deepPurple
                              : Colors.deepPurple[50],
                          textcolor: isOparator(buttons[index])
                              ? Colors.white
                              : Colors.deepPurple,
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }

  bool isOparator(String x) {
    if (x == '%' || x == 'x' || x == '-' || x == '+' || x == '/' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    userAnswer = eval.toString();
  }
}
