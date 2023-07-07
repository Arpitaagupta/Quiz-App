import 'package:http/http.dart' as http; //the http package
import '../models/question_models.dart';
import 'dart:convert';

class DBconnect {
//lets first create a function to add question to our database
  final url = Uri.parse(
      'https://simplequizapp-789bc-default-rtdb.firebaseio.com/questions.json');
  Future<void> addQuestion(Question question) async {
    http.post(url,
        body: json.encode({
          'title': question.title,
          'options': question.options,
        }));
  }

//fetch the data from data base
  Future<void> fetchQuestions() async {
    //we got the data from just using this. now let us print to se what we got
    http.get(url).then((response) {
      // the then method returns a response
      //to whats inside we have to decode it first
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];

      data.forEach(
        (key, value) {
          var newQuestion = Question(
            id: key, //the encrypted key/title given to data
            title: value['title'], //title of the question
            options: Map.castFrom(value['options']), //options of the question
          );
          //add to new questions
          newQuestions.add(newQuestion);
        },
      );
      print(newQuestions);
    });
  }
}
