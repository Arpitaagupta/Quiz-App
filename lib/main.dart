//import the material package
import 'package:flutter/material.dart';
import 'package:quizz_app/models/question_models.dart';
import 'screens/home_screens.dart';
import './models/db_connection.dart';

//run the main method
void main() {
  var db = DBconnect();
  db.addQuestion(Question(
      id: '20',
      title:
          'Alluri Sitaram Raju was a tribal freedom fighter from which state of India?',
      options: {
        ' Bihar': false,
        'Maharashtra': false,
        'Andhra Pradesh': true,
        'Gujurat': false,
      }));
  //runApp method
  runApp(
    const MyApp(),
  );
}

//creating MyApp widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //removing debug banner
      //set homepage
      home: HomeScreen(), //this method is created in separate file
    );
  }
}
