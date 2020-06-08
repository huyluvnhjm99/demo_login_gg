
import 'dart:convert';

import 'package:demologingg/models/PersonalityTest.dart';
import 'package:demologingg/models/api.services.dart';
import 'package:flutter/material.dart';

class PersonalityTests extends StatefulWidget {
  PersonalityTests({Key key}):super(key:key);

  @override
  __PersonalityTestsState createState() => __PersonalityTestsState();
}

class __PersonalityTestsState extends State<PersonalityTests> {
  List<PersonalityTest> personalityTests;
  getPersonalityTests() {
    APIServices.fectPersonalityTest().then((response) {
      Iterable list = json.decode(response.body);
      List<PersonalityTest> perTestList = List<PersonalityTest>();
      perTestList = list.map((model) => PersonalityTest.fromObject(model)).toList();

      setState(() {
        personalityTests = perTestList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getPersonalityTests();
    return Scaffold(
      appBar: AppBar(
        title: Text('Personality Test'),centerTitle: true, backgroundColor: Colors.deepPurpleAccent[400],
      ),
      body: personalityTests==null ? Center(child: Text('Empty'),) : ListView.builder(
        itemCount: personalityTests.length,
        itemBuilder: (context, index) {
          return
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18.0 / 11.0,
                    child: Image.network(personalityTests[index].image, height: 200,),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(onPressed: () {
                          displayInformation(context, personalityTests[index]);
                        }, child: Text('Information', style: TextStyle(fontWeight: FontWeight.bold),), color: Colors.deepPurpleAccent[400], textColor: Colors.white,),
                        SizedBox(width: 12,),
                        RaisedButton(onPressed: () {}, child: Text('Test Now', style: TextStyle(fontWeight: FontWeight.bold),), color: Colors.deepPurpleAccent[400], textColor: Colors.white,),
                      ],
                    ),
                  ),
                ],
              ),
            );
//            Card(
//              color: Colors.white,
//              elevation: 2.0,
//               child: IconButton(icon: Image.network(personalityTests[index].image), onPressed: null, iconSize: 250,)
//            );
//            Card(
//            color: Colors.white,
//            elevation: 2.0,
//            child: ListTile(
//              title: ListTile(
//                title: Text(personalityTests[index].type + "\n\n" + personalityTests[index].description + "\n"),
//                onTap: null,
//              ),
//            ),
        },
      ),
    );
  }

  void displayInformation(BuildContext context, PersonalityTest personalityTest) {
    var arlertDialog = AlertDialog(
      title: Text(personalityTest.type),
      content: Text(personalityTest.description),
      
    );

    showDialog(
      context: context,
      builder: (context) =>  arlertDialog,
    );
  }
}