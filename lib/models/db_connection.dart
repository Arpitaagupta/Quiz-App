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
}
