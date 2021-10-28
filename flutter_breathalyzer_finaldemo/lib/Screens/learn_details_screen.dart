import'package:flutter/material.dart';
import 'package:flutter_breathalyzer/Components/learnpages.dart';

class LearnDetailsScreen extends StatelessWidget{
  final Learn learn;

  const LearnDetailsScreen(this.learn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(learn.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Image.network(
                learn.imageUrl,
                height: 300,
                width: 500,
              ),
              Text(
                learn.author,
                textAlign: TextAlign.center,
                style: const TextStyle(height:1.2, fontSize:18.0, fontWeight: FontWeight.w600),
              ),
              Text(
                learn.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(height:1.2, fontSize: 16.0, fontWeight: FontWeight.w600),
              )
            ]
          ),
        )
      )
    );
  }
  }