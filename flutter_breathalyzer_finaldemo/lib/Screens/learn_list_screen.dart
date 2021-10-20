import 'package:flutter/material.dart';
import 'package:flutter_breathalyzer/Component/learnpages.dart';
import 'package:flutter_breathalyzer/Screens/learn_details_screen.dart';

class LearnListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn More About AUD'),
      ),
      body: ListView.builder(
      itemCount: learnList.length,
      itemBuilder: (context, index) {
        Learn learn=learnList[index];
        return Card(
          child: SingleChildScrollView(
            child: ListTile(
              title: Text(
                  learn.title,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)
              ),
              subtitle: Text(
                  learn.author,
                  style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600)
              ),
              leading: Image.network(
                  learn.imageUrl,
                  height: 90,
                  width: 90,
              ),
              trailing: Icon(Icons.arrow_forward_rounded),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder:(context) => LearnDetailsScreen(learn)));
              }
            ),
          )
        );
    }));
  }
}
