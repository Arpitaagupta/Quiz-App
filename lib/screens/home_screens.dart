//import the material package
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/question_models.dart'; //question model
import '../widgets/questions_widgets.dart'; //the question widget
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';
import '../models/db_connection.dart';

//Creating the HomeScreen widget
//Stateful Widget is used because it is going to be our parent widget
//and all the functions and variables will be in this widget, so we will need to change the state of our widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //create an object for DBconnect
  var db = DBconnect();
  late Future _questions;
  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void initState() {
    //  implement initState
    _questions = getData();
    super.initState();
  }

  /* List<Question> _questions = [
    Question(
      id: '10',
      title: 'Which is the largest planet in solar system ?',
      options: {
        'Mars': false,
        'Earth': false,
        'Jupiter': true,
        'Uranus': false
      },
    ),
    Question(
      id: '11',
      title: 'In which ocean "Bermuda Triangle" region is located ?',
      options: {
        'Atlantic': true,
        'Indian': false,
        'Pacific': false,
        'Arctic': false
      },
    ),
    Question(
      id: '12',
      title: 'Which country is also known as "Land of Rising Sun"?',
      options: {
        'China': false,
        'New Zealand': false,
        'Fiji': false,
        'Japan': true
      },
    ),
    Question(
      id: '13',
      title: 'Which is the biggest Island in the world ?',
      options: {
        'Borneo': false,
        'Finland': false,
        'Sumatra': false,
        'Greenland': true
      },
    ),
    Question(
      id: '14',
      title: 'Which is the smallest ocean in the world ?',
      options: {
        'Atlantic': false,
        'Arctic': true,
        'Pacific': false,
        'Indian': false
      },
    ),
    Question(
      id: '15',
      title: 'Who discovered gravity ?',
      options: {
        'Einstein': false,
        'E. Goldstein': false,
        'Chadwick': false,
        'Newton': true
      },
    ),
    Question(
      id: '16',
      title: 'Who climbed Mt. Everest first ?',
      options: {
        'Tenzing Norway': false,
        'Edmund Hillary': false,
        'All of the above': true,
        'None of the above': false
      },
    ),
    Question(
      id: '17',
      title: 'Where is river Thames located ?',
      options: {
        'Hong Kong': false,
        'London': true,
        'Paris': false,
        'Switzerland': false
      },
    ),
    Question(
      id: '18',
      title: 'Who is first Indian Woman to go in space ?',
      options: {
        'Kalpana Chawla': true,
        'Priyanka Srivastav': false,
        'Yogita Shah': false,
        'Swati Mohan': false
      },
    ),
    Question(
      id: '19',
      title: 'Which is the largest desert in India ?',
      options: {
        'Indus Valley Desert': false,
        'Jaisalmer': false,
        'Thar': true,
        'Bikaner': false
      },
    ),
  ];
 */
  //creating an index to loop through questions
  int index = 0;
  //create a score variable
  int score = 0;

  //create a boolean value to check if the user has clicked
  bool isPressed = false;
  bool isAlreadySelected = false;

  //create a function to display next question
  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      //this is the block where question ends
      showDialog(
          context: context,
          barrierDismissible:
              false, //this will disable the dismiss function on clicking outside of box
          builder: (ctx) => ResultBox(
                result: score, //total points the user got
                questionLength: questionLength, //out of how many questions
                onPressed: startOver,
              ));
    } else {
      if (isPressed) {
        setState(
          () {
            index++; //when the index change to 1. rebuild the app
            isPressed = false;
            isAlreadySelected = false;
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Please select any option to continue!',
            // textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  //create a function for changing color
  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value) {
        // Increment the score only if the answer is correct
        setState(() {
          score++;
        });
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  //create a function start over
  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //use the future builder widget

    //change the background

    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                title: const Text('Quiz App'),
                backgroundColor: skyBlueColor,
                shadowColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Score : $score',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    //adding QuestionsWidget here,
                    QuestionWidget(
                      indexAction: index, //currently at 0.
                      question: extractedData[index]
                          .title, //means the first question in the list
                      totalQuestions:
                          extractedData.length, //total length of the list
                    ),
                    const Divider(
                      color: neutral,
                    ),
                    //add some space,
                    const SizedBox(height: 25.0),
                    for (int i = 0;
                        i < extractedData[index].options.length;
                        i++)
                      GestureDetector(
                        onTap: () => checkAnswerAndUpdate(
                            extractedData[index].options.values.toList()[i]),
                        child: OptionCard(
                          option: extractedData[index].options.keys.toList()[i],
                          //we need to check if the answer is correct or not,

                          color: isPressed
                              ? extractedData[index]
                                          .options
                                          .values
                                          .toList()[i] ==
                                      true
                                  ? correct
                                  : incorrect
                              : neutral,
                          // onTap: changeColor,
                        ),
                      ),
                  ],
                ),
              ),

              //use the floating action button,
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Please wait while questions are loading..',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
          );
        }
        return const Center(
          child: Text('No data'),
        );
      },
    );
  }
}

//import this file to main.dart file
