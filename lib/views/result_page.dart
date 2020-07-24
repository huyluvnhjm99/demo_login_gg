import 'dart:async';
import 'dart:collection';

import 'package:demologingg/data/Answer.dart';
import 'package:demologingg/data/Personality.dart';
import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/data/Question.dart';
import 'package:demologingg/data/Result.dart';
import 'package:demologingg/dependency/presenter/MainPresenter.dart';
import 'package:demologingg/views/personalityTests.dart';
import 'package:flutter/material.dart';
import 'package:demologingg/sign_in.dart';
import 'package:demologingg/views/login_page.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResultPage extends StatefulWidget {

  final List<Question> listQuestion;
  final String testName;
  ResultPage({Key key, @required this.listQuestion, @required this.testName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return new _ResultPageState();
  }
}

class _ResultPageState extends State<ResultPage> implements PersonalityView, ResultView {
  Map _listPersonalities;
  PersonalityPresenter _presenter;
  ResultPresenter _resultPresenter;
  List<Personality> _perList;
  bool _isLoading;

  _ResultPageState() {
    _presenter = new PersonalityPresenter(this);
    _resultPresenter = new ResultPresenter(this);
    _listPersonalities = new Map<Personality, dynamic>();
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadPersonality();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[400],
          title: new Text('Result'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: InkWell(onTap: _showPopupMenu,child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),radius: 25)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 70),
                    Center(child: CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl), backgroundColor: Colors.white,),),
                    SizedBox(height: 12),
                    Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),),),
                    SizedBox(height: 30),
                    Center(child: Text('YOU ARE IN', style: TextStyle(fontSize: 15, color: Colors.grey[500]),),),
                    Center(child: Card(
                      color: Colors.deepPurpleAccent[400],
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 6, 20, 6),
                        child: _listPersonalities.entries.isEmpty ? Text('Please wailt')
                            : Text(_listPersonalities.entries.first.key.type, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 60,
                        )
                        ),),
                    )),
                    SizedBox(height: 70),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(5),
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: <Widget>[
                  for(Personality k in _listPersonalities.keys)
                    Card(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Text(k.type + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            CircularPercentIndicator(
                              radius: 100,
                              lineWidth: 9.0,
                              center: new Text((_listPersonalities[k] * 100).toStringAsFixed(2) + '%'),
                              percent: _listPersonalities[k],
                              backgroundColor: Colors.grey[200],
                              progressColor: Colors.deepPurpleAccent[400],
                            ),
                            RaisedButton(onPressed: () => displayInformation(context, k), child: Text('Informarion', style: TextStyle(fontSize: 10, color: Colors.white)), color: Colors.deepPurpleAccent[400], padding: EdgeInsets.all(0),)
                          ],
                        )
                    ),
                ],
              ),
              SizedBox(height: 200,)
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 100),
      items: [
        PopupMenuItem(
          child: FlatButton(onPressed: () {
            signOutGoogle();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
          }, child: Text("Sign Out", style: TextStyle(color: Colors.redAccent),)),
        ),
      ],
      elevation: 8.0,
    );
  }

  void displayInformation(BuildContext context, Personality per) {
    var arlertDialog = AlertDialog(
      title: Text(per.type),
      content: Text(per.description),
    );

    showDialog(
      context: context,
      builder: (context) => arlertDialog,
    );
  }

  @override
  void onSuccess(List<Personality> listPersonality) {
    setState(() {
      _isLoading = false;
      _perList = listPersonality;
      _presenter.loadPersonality();
      if(_listPersonalities.isEmpty) {
        _calculateResult();
      }
    });
  }



  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you exit!?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalityTests()));},
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }




  void _calculateResult() {
    widget.listQuestion.forEach((quest) {
      quest.list_answers.forEach((answer) {
        if(answer.isChosen) {
          _listPersonalities.containsKey(_getPersonalityDetail(answer.personality_id))
              ? _listPersonalities[_getPersonalityDetail(answer.personality_id)] = _listPersonalities[_getPersonalityDetail(answer.personality_id)] + 1
              : _listPersonalities.putIfAbsent(_getPersonalityDetail(answer.personality_id), () => 1);
        }
      });
    });

    double total = 0;
    _listPersonalities.values.forEach((v) {
      total += v;
    });


    var tmp = _listPersonalities.entries.toList();
    tmp.sort((a, b) => b.value.compareTo(a.value));
    _listPersonalities = Map<dynamic, dynamic>.fromEntries(tmp);

    _listPersonalities.keys.forEach((k) {
      _listPersonalities[k] = (_listPersonalities[k] / total);
    });

    Result result = new Result(email, widget.testName, _listPersonalities.entries.first.key.type);
    result.date_create = new DateTime.now();
    _resultPresenter.postResult(result, token);
  }


  Personality _getPersonalityDetail(int perID) {
    Personality result;
    for(var per in _perList) {
      if(per.id == perID) {
        result = per;
        break;
      }
    }
    return result;
  }

  @override
  void onSuccesss(List<Result> resultList) {
    // TODO: implement onSuccesss
  }
}