import 'package:http/http.dart' as http; //the http package
import '../models/question_models.dart';

class DBconnect {

//lets first create a function to add question to our database
  final url = Uri.parse(
    //paste the address here
  )
  Future<void> addQuestion(Question question) async {
    http.post(url)
  }
}
