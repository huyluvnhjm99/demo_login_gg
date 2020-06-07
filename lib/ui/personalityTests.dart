
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
        title: Text('Personality Test'),centerTitle: true,
      ),
      body: personalityTests==null ? Center(child: Text('Empty'),) : ListView.builder(
        itemCount: personalityTests.length,
        itemBuilder: (context, index) {
          return
            Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
                title: Text(personalityTests[index].type + "\n\n" + personalityTests[index].description + "\n"),
                onTap: null,
              ),
            ),
          );
        },
      ),
    );
  }
}