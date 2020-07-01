import 'dart:collection';

import 'package:demologingg/data/Answer.dart';
import 'package:demologingg/data/Personality.dart';
import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/data/Question.dart';
import 'package:demologingg/dependency/presenter/MainPresenter.dart';
import 'package:demologingg/views/result_page.dart';
import 'package:flutter/material.dart';
import 'package:demologingg/sign_in.dart';
import 'package:demologingg/views/login_page.dart';

class QuizPage extends StatefulWidget {

  final PersonalityTest perTest;
  QuizPage({Key key, @required this.perTest}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> implements QuestionListView {
  QuestionPresenter _presenter;
  List<Question> _listQuestion;
  List<Answer> _listAnswer;
  List<Personality> _perList;
  bool _isLoading;
  bool _isDone;

  _QuizPageState() {
    _presenter = new QuestionPresenter(this);
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isDone = false;
    _presenter.loadQuestionList(widget.perTest.id);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[400],
          title: new Text(widget.perTest.type),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: InkWell(onTap: _showPopupMenu,child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),radius: 25)),
            ),
          ],
        ),
        body: _listQuestion == null ? Center(child: Text('Please wait ...', style: TextStyle(color: Colors.deepPurpleAccent[400], fontSize: 25, fontWeight: FontWeight.bold),))
            :  widget.perTest.type == 'MBTI' ?
        PageView.builder(itemCount: _listQuestion.length,itemBuilder: (context, index) {
            return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.fromLTRB(30, 50, 30, 85),
                child: Padding(padding: EdgeInsets.fromLTRB(20, 65, 20, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Q.' + (index + 1).toString() + ': ' + _listQuestion[index].question_content, style: TextStyle(fontSize: 28)),
                      SizedBox(height: 45),

                      _listQuestion[index].list_answers.length >= 1  ?
                      OutlineButton(
                        onPressed: () {
                            pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                            _listQuestion[index].list_answers.forEach((answer) {answer.isChosen = false;});
                            _listQuestion[index].list_answers[0].isChosen = true;
                            _listQuestion[index].isChosen = true;
                            setState(() {_isDone = isDone();});
                        },
                        splashColor: Colors.deepPurpleAccent[400],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        child: Container(
                            width: 1000,
                            padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                            child: _listQuestion[index].list_answers[0].isChosen ?
                             Text(_listQuestion[index].list_answers[0].answer_content, style: TextStyle(fontSize: 20, color: Colors.deepPurpleAccent[400]))
                                : Text(_listQuestion[index].list_answers[0].answer_content, style: TextStyle(fontSize: 20),)
                        ),
                      ) : Text(''),

                      _listQuestion[index].list_answers.length >= 2 ? SizedBox(height: 15) : Text(''),


                      _listQuestion[index].list_answers.length >= 2 ?
                      OutlineButton(
                        onPressed: () {
                          pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                          _listQuestion[index].list_answers.forEach((answer) {answer.isChosen = false;});
                          _listQuestion[index].list_answers[1].isChosen = true;
                          _listQuestion[index].isChosen = true;
                          setState(() {_isDone = isDone();});
                        },
                        splashColor: Colors.deepPurpleAccent[400],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        child: Container(
                            width: 1000,
                            padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                            child: _listQuestion[index].list_answers[1].isChosen ?
                            Text(_listQuestion[index].list_answers[1].answer_content, style: TextStyle(fontSize: 20, color: Colors.deepPurpleAccent[400]))
                                : Text(_listQuestion[index].list_answers[1].answer_content, style: TextStyle(fontSize: 20),)
                        ),
                      ) : Text(''),

                      _isDone == true ? Container(
                        margin: EdgeInsets.only(left: 110, top: 10),
                        child: RaisedButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(listQuestion: _listQuestion, testName: widget.perTest.type,)));},
                          color: Colors.deepPurpleAccent[400],
                          child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                        ),
                      ) : Text(''),
                    ],
                  ),
                )
            );
          }, controller: pageController, physics: NeverScrollableScrollPhysics())
            :
        PageView.builder(itemCount: (_listQuestion.length / 4).toInt(), itemBuilder: (context, index) {
          return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.fromLTRB(30, 50, 30, 85),
              child: Padding(padding: EdgeInsets.fromLTRB(20, 65, 20, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: _listQuestion[index * 4 + 0].list_answers.first.isChosen ?
                            Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                            onPressed: () {
                              _setChosenFirst(index);
                              _listQuestion[index * 4 + 0].list_answers.first.isChosen = true;
                              _listQuestion[index * 4 + 0].list_answers.last.isChosen = false;
                              setState(() {});
                            },
                            iconSize: 50,
                        ),
                        IconButton(
                            icon: _listQuestion[index * 4 + 0].list_answers.last.isChosen ?
                            Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                            onPressed: () {
                              _setChosenLast(index);
                              _listQuestion[index * 4 + 0].list_answers.last.isChosen = true;
                              _listQuestion[index * 4 + 0].list_answers.first.isChosen = false;
                              setState(() {});
                            },
                            iconSize: 50,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 0].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _listQuestion[index * 4 + 1].list_answers.first.isChosen ?
                          Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                          onPressed: () {
                            _setChosenFirst(index);
                            _listQuestion[index * 4 + 1].list_answers.first.isChosen = true;
                            _listQuestion[index * 4 + 1].list_answers.last.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 50,
                        ),
                        IconButton(
                          icon: _listQuestion[index * 4 + 1].list_answers.last.isChosen ?
                          Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                          onPressed: () {
                            _setChosenLast(index);
                            _listQuestion[index * 4 + 1].list_answers.last.isChosen = true;
                            _listQuestion[index * 4 + 1].list_answers.first.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 50,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 1].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _listQuestion[index * 4 + 2].list_answers.first.isChosen ?
                          Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                          onPressed: () {
                            _setChosenFirst(index);
                            _listQuestion[index * 4 + 2].list_answers.first.isChosen = true;
                            _listQuestion[index * 4 + 2].list_answers.last.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 50,
                        ),
                        IconButton(
                          icon: _listQuestion[index * 4 + 2].list_answers.last.isChosen ?
                          Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                          onPressed: () {
                            _setChosenLast(index);
                            _listQuestion[index * 4 + 2].list_answers.last.isChosen = true;
                            _listQuestion[index * 4 + 2].list_answers.first.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 50,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 2].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _listQuestion[index * 4 + 3].list_answers.first.isChosen ?
                          Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                          onPressed: () {
                            _setChosenFirst(index);
                            _listQuestion[index * 4 + 3].list_answers.first.isChosen = true;
                            _listQuestion[index * 4 + 3].list_answers.last.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 50,
                        ),
                        IconButton(
                          icon: _listQuestion[index * 4 + 3].list_answers.last.isChosen ?
                          Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                          onPressed: () {
                            _setChosenLast(index);
                            _listQuestion[index * 4 + 3].list_answers.last.isChosen = true;
                            _listQuestion[index * 4 + 3].list_answers.first.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 50,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 3].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),

                    SizedBox(height: 20),

                    _isNext(index) ? _isDone2() ?  Container(
                      margin: EdgeInsets.only(left: 110, top: 10),
                      child: RaisedButton(
                        onPressed: () {
                          pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                        },
                        color: Colors.deepPurpleAccent[400],
                        child: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    )
                        :
                    Container(
                      margin: EdgeInsets.only(left: 110, top: 10),
                      child: RaisedButton(
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(listQuestion: _listQuestion, testName: widget.perTest.type,)));},
                        color: Colors.deepPurpleAccent[400],
                        child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    )
                        : Text(''),
                  ],
                ),
              )
          );
        }, controller: pageController, physics: NeverScrollableScrollPhysics()),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  @override
  void onSuccess(List<Question> questionList) {
    setState(() {
      _isLoading = false;
      _listQuestion = questionList;
      _presenter.loadAnswerForQuestion(_listQuestion);
    });
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 100),
      items: [
        PopupMenuItem(
          child: Text("View"),
        ),
        PopupMenuItem(
          child: Text("Edit"),
        ),
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you exit the quiz !?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

 void _setChosenLast(int index) {
    _listQuestion[index * 4 + 0].list_answers.last.isChosen = false;
    _listQuestion[index * 4 + 1].list_answers.last.isChosen = false;
    _listQuestion[index * 4 + 2].list_answers.last.isChosen = false;
    _listQuestion[index * 4 + 3].list_answers.last.isChosen = false;
 }

  void _setChosenFirst(int index) {
    _listQuestion[index * 4 + 0].list_answers.first.isChosen = false;
    _listQuestion[index * 4 + 1].list_answers.first.isChosen = false;
    _listQuestion[index * 4 + 2].list_answers.first.isChosen = false;
    _listQuestion[index * 4 + 3].list_answers.first.isChosen = false;
  }

  bool isDone() {
    int x = 0;
    _listQuestion.forEach((quest) {
      if(!quest.isChosen) {
        x++;
      }
    });
    return x == 0 ? true : false;
  }

  bool _isDone2() {
    int x = 0;
    for(int i = 0; i < (_listQuestion.length / 4); i++) {
      if(!_isNext(i)) {
        x++;
        break;
      }
    }
    return x > 0;
  }

  bool _isNext(int index) {
    int x = 0;
    for(int i = 0; i <= 3; i++) {
      if(_listQuestion[index * 4 + i].list_answers.first.isChosen) {
        x++;
      }
      if(_listQuestion[index * 4 + i].list_answers.last.isChosen) {
        x++;
      }
    }
    return x == 2 ? true : false;
  }
}