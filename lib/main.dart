import 'package:flutter/material.dart';
import 'quiz-brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  //กำหนดให้ scoreKeeper เริ่มต้นเป็นลิสต์ว่าง
  List<Icon> scoreKeeper = [];
  int totalScore = 0;

  void checkAnswer(bool user_ans) {
    bool correctAnswer = quizBrain.getQuestionAnswer()!;

    setState(() {
      if (correctAnswer == user_ans) {
        //เพิ่มข้อมูลเข้าไปในลิสต์ scoreKeeper โดยใช้ add method
        totalScore++;
        scoreKeeper.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
      } else {
        scoreKeeper.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
      }
      if (quizBrain.isFinished()) {
        Alert(
            context: context,
            style: AlertStyle(
              isCloseButton: false,
              isOverlayTapDismiss: false,
            ),
            title: totalScore >=
                    (0.6 * (quizBrain.getQuestionLength())).ceil()
                ? 'Great Job!'
                : 'Better Luck Next Time',
            desc: "$totalScore/${quizBrain.getQuestionLength()}.",
            buttons: [
              DialogButton(
                child: Text(
                  "Try Again",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    quizBrain.reset();
                    scoreKeeper = [];
                    totalScore = 0;
                  });
                  Navigator.of(context).pop();
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
            ]).show();
      } else
        quizBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: SizedBox(),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, right: 40.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 50,
                  child: Text(
                    'Question: ${quizBrain.getQuestionNumber() + 1}/${quizBrain.getQuestionLength()}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: Text(
                    '$totalScore',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: SizedBox(),
        ),
        Expanded(
          flex: 25,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  quizBrain.getQuestionText()!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 80.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: SizedBox(),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        //แสดงผล icon สำหรับ scoreKeeper
        Expanded(
          flex: 8,
          child: Row(
            children: scoreKeeper,
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(),
        ),
      ],
    );
  }
}
