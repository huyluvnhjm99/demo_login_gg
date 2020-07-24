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
import 'package:percent_indicator/linear_percent_indicator.dart';

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
  int _point;
  PageController pageController;

  _QuizPageState() {
    _presenter = new QuestionPresenter(this);
      pageController = PageController (
      initialPage: 0,
      keepPage: true,
    );
  }



  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isDone = false;
    _point = 0;
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
                child: Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LinearPercentIndicator(
                        width: 310,
                        animation: true,
                        animationDuration: 500,
                        lineHeight: 15.0,
                        percent: _getTotalChosenQuestion() / _getTotalQuestion(),
                        center: Text(_getTotalChosenQuestion().toString() + "/" + _getTotalQuestion().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Colors.deepPurpleAccent[200],
                      ),
                      SizedBox(height: 30),
                      Text('Q.' + (index + 1).toString() + ': ' + _listQuestion[index].question_content, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),

                      _listQuestion[index].list_answers.length >= 1  ?
                      OutlineButton(
                        onPressed: () {
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

                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 55),
                            child: RaisedButton(
                              onPressed: () {
                                pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.deepPurpleAccent[400])
                              ),
                              child: Text('Back', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                            ),
                          ),
                          _isDone == true ? Container(
                            margin: EdgeInsets.only(left: 30, top: 55),
                            child: RaisedButton(
                              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(listQuestion: _listQuestion, testName: widget.perTest.type,)));},
                              color: Colors.deepPurpleAccent[400],
                              child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ) : _isNext2(index) == true ? Container(
                            margin: EdgeInsets.only(left: pageController.page > 0 ? 30 : 30, top: 55),
                            child: RaisedButton(
                              onPressed: () {
                                pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                              },
                              color: Colors.deepPurpleAccent[400],
                              child: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                          ) : Text(''),
                        ],
                      ),

//                      _isDone == true ? Container(
//                        margin: EdgeInsets.only(left: 110, top: 10),
//                        child: RaisedButton(
//                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(listQuestion: _listQuestion, testName: widget.perTest.type,)));},
//                          color: Colors.deepPurpleAccent[400],
//                          child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
//                        ),
//                      ) : Text(''),
                    ],
                  ),
                )
            );
          }, controller: pageController, physics: NeverScrollableScrollPhysics())
            : widget.perTest.type == 'DiSC profile' ?
        PageView.builder(itemCount: (_listQuestion.length / 4).toInt(), itemBuilder: (context, index) {
          return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.fromLTRB(30, 50, 30, 85),
              child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    LinearPercentIndicator(
                      width: 310,
                      animation: true,
                      animationDuration: 500,
                      lineHeight: 15.0,
                      percent: _getTotalChosenQuestion() / (((_getTotalQuestion())/ 4)),
                      center: Text(_getTotalChosenQuestion().toString() + "/" + (((_getTotalQuestion())/4)).round().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                      linearStrokeCap: LinearStrokeCap.butt,
                      progressColor: Colors.deepPurpleAccent[200],
                    ),
                    Padding(
                      padding:EdgeInsets.fromLTRB(280, 0, 0, 20),
                      child: IconButton(icon: Icon(Icons.info), onPressed: () {
                        displayDiSCGuide(context, "DiSC");
                      }),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: _listQuestion[index * 4 + 0].list_answers.first.isChosen ?
                            Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                            onPressed: () {
                              _setChosenFirst(index);
                              _listQuestion[index * 4 + 0].list_answers.first.isChosen = true;
                              _listQuestion[index * 4 + 0].isChosen = true;
                              _listQuestion[index * 4 + 0].list_answers.last.isChosen = false;
                              setState(() {});
                            },
                            iconSize: 35,
                        ),
                        IconButton(
                            icon: _listQuestion[index * 4 + 0].list_answers.last.isChosen ?
                            Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                            onPressed: () {
                              _setChosenLast(index);
                              _listQuestion[index * 4 + 0].list_answers.last.isChosen = true;
                              _listQuestion[index * 4 + 0].isChosen = true;
                              _listQuestion[index * 4 + 0].list_answers.first.isChosen = false;
                              setState(() {});
                            },
                            iconSize: 35,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 0].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _listQuestion[index * 4 + 1].list_answers.first.isChosen ?
                          Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                          onPressed: () {
                            _setChosenFirst(index);
                            _listQuestion[index * 4 + 1].list_answers.first.isChosen = true;
                            _listQuestion[index * 4 + 1].isChosen = true;
                            _listQuestion[index * 4 + 1].list_answers.last.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 35,
                        ),
                        IconButton(
                          icon: _listQuestion[index * 4 + 1].list_answers.last.isChosen ?
                          Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                          onPressed: () {
                            _setChosenLast(index);
                            _listQuestion[index * 4 + 1].list_answers.last.isChosen = true;
                            _listQuestion[index * 4 + 1].isChosen = true;
                            _listQuestion[index * 4 + 1].list_answers.first.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 35,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 1].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _listQuestion[index * 4 + 2].list_answers.first.isChosen ?
                          Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                          onPressed: () {
                            _setChosenFirst(index);
                            _listQuestion[index * 4 + 2].list_answers.first.isChosen = true;
                            _listQuestion[index * 4 + 2].isChosen = true;
                            _listQuestion[index * 4 + 2].list_answers.last.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 35,
                        ),
                        IconButton(
                          icon: _listQuestion[index * 4 + 2].list_answers.last.isChosen ?
                          Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                          onPressed: () {
                            _setChosenLast(index);
                            _listQuestion[index * 4 + 2].list_answers.last.isChosen = true;
                            _listQuestion[index * 4 + 2].isChosen = true;
                            _listQuestion[index * 4 + 2].list_answers.first.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 35,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 2].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: _listQuestion[index * 4 + 3].list_answers.first.isChosen ?
                          Image.asset('assets/like.png') : Image.asset('assets/like1.png'),
                          onPressed: () {
                            _setChosenFirst(index);
                            _listQuestion[index * 4 + 3].list_answers.first.isChosen = true;
                            _listQuestion[index * 4 + 3].isChosen = true;
                            _listQuestion[index * 4 + 3].list_answers.last.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 35,
                        ),
                        IconButton(
                          icon: _listQuestion[index * 4 + 3].list_answers.last.isChosen ?
                          Image.asset('assets/unlike.png') : Image.asset('assets/unlike1.png'),
                          onPressed: () {
                            _setChosenLast(index);
                            _listQuestion[index * 4 + 3].list_answers.last.isChosen = true;
                            _listQuestion[index * 4 + 3].isChosen = true;
                            _listQuestion[index * 4 + 3].list_answers.first.isChosen = false;
                            setState(() {});
                          },
                          iconSize: 35,
                        ),
                        Expanded(child: Text(_listQuestion[index * 4 + 3].question_content, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                      ],
                    ),

                    SizedBox(height: 15),

                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 5),
                          child: RaisedButton(
                            onPressed: () {
                              pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.deepPurpleAccent[400])
                            ),
                            child: Text('Back', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                          ),
                        ),
                        _isNext(index) ? _isDone2() ?  Container(
                          margin: EdgeInsets.only(left: 95, top: 5),
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
                  ],
                ),
              )
          );
        }, controller: pageController, physics: NeverScrollableScrollPhysics())
        //HollandCode
            : PageView.builder(itemCount: _listQuestion.length,itemBuilder: (context, index) {
          return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.fromLTRB(30, 50, 30, 85),
              child: Padding(padding: EdgeInsets.fromLTRB(0, 4, 0, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LinearPercentIndicator(
                      width: 350,
                      animation: true,
                      animationDuration: 500,
                      lineHeight: 15.0,
                      percent: _getTotalChosenQuestion() / _getTotalQuestion(),
                      center: Text(_getTotalChosenQuestion().toString() + "/" + _getTotalQuestion().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                      linearStrokeCap: LinearStrokeCap.butt,
                      progressColor: Colors.deepPurpleAccent[200],
                    ),
                    Padding(
                      padding:EdgeInsets.fromLTRB(280, 0, 0, 5),
                      child: IconButton(icon: Icon(Icons.info), onPressed: () {
                        displayDiSCGuide(context, "HOLLAND");
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 2, 20, 45),
                        child: Text('Q.' + (index + 1).toString() + ': ' + _listQuestion[index].question_content, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8),
                    Row(children: <Widget>[
                      //111111
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _unChosen(index);
                            _setChosen(index, 1);
                            _listQuestion[index].isChosen = true;
                            setState(() {_isDone = isDone(); _point = 1;});
                          },
                          child: Icon(Icons.star, color: _numOfChosen(index) >= 1 ? Colors.orange : Colors.grey, size: 70),
                        ),
                      ),
                      //2222222
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _unChosen(index);
                            _setChosen(index, 2);
                            _listQuestion[index].isChosen = true;
                            setState(() {_isDone = isDone(); _point = 2;});
                          },
                          child: Icon(Icons.star, color: _numOfChosen(index) >= 2 ? Colors.orange : Colors.grey, size: 70),
                        ),
                      ),
                      //333333333
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _unChosen(index);
                            _setChosen(index, 3);
                            _listQuestion[index].isChosen = true;
                            setState(() {_isDone = isDone(); _point = 3;});
                          },
                          child: Icon(Icons.star, color: _numOfChosen(index) >= 3 ? Colors.orange : Colors.grey, size: 70),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _unChosen(index);
                            _setChosen(index, 4);
                            _listQuestion[index].isChosen = true;
                            setState(() {_isDone = isDone(); _point = 4;});
                          },
                          child: Icon(Icons.star, color: _numOfChosen(index) >= 4 ? Colors.orange : Colors.grey, size: 70),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _unChosen(index);
                            _setChosen(index, 5);
                            _listQuestion[index].isChosen = true;
                            setState(() {_isDone = isDone(); _point = 5;});
                          },
                          child: Icon(Icons.star, color: _numOfChosen(index) >= 5 ? Colors.orange : Colors.grey, size: 70),
                        ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Center(
                      child: Text(getDescript(_isNext2(index) == true ? _point : 0), style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 55),
                          child: RaisedButton(
                            onPressed: () {
                              pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.deepPurpleAccent[400])
                            ),
                            child: Text('Back', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                          ),
                        ),
                        _isDone == true ? Container(
                          margin: EdgeInsets.only(left: 30, top: 55),
                          child: RaisedButton(
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(listQuestion: _listQuestion, testName: widget.perTest.type,)));},
                            color: Colors.deepPurpleAccent[400],
                            child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ) : _isNext2(index) == true ? Container(
                          margin: EdgeInsets.only(left: 30, top: 55),
                          child: RaisedButton(
                            onPressed: () {
                              pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                            },
                            color: Colors.deepPurpleAccent[400],
                            child: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                        ) : Text(''),
                      ],
                    ),
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

  int _getTotalQuestion() {
    int result = 0;
    _listQuestion.forEach((quest) {
      result ++;
    });
    return result;
  }

  int _getTotalChosenQuestion() {
    int result = 0;
    _listQuestion.forEach((quest) {
      if(quest.isChosen) {
        result ++;
      }
    });
    return result;
  }

 void _setChosenLast(int index) {
    _listQuestion[index * 4 + 0].list_answers.last.isChosen = false;
    _listQuestion[index * 4 + 1].list_answers.last.isChosen = false;
    _listQuestion[index * 4 + 2].list_answers.last.isChosen = false;
    _listQuestion[index * 4 + 3].list_answers.last.isChosen = false;

    _listQuestion[index * 4 + 0].isChosen = false;
    _listQuestion[index * 4 + 1].isChosen = false;
    _listQuestion[index * 4 + 2].isChosen = false;
    _listQuestion[index * 4 + 3].isChosen = false;
 }

  void _setChosenFirst(int index) {
    _listQuestion[index * 4 + 0].list_answers.first.isChosen = false;
    _listQuestion[index * 4 + 1].list_answers.first.isChosen = false;
    _listQuestion[index * 4 + 2].list_answers.first.isChosen = false;
    _listQuestion[index * 4 + 3].list_answers.first.isChosen = false;

    _listQuestion[index * 4 + 0].isChosen = false;
    _listQuestion[index * 4 + 1].isChosen = false;
    _listQuestion[index * 4 + 2].isChosen = false;
    _listQuestion[index * 4 + 3].isChosen = false;
  }

  void _setChosen(int index, int point) {
    _listQuestion[index].isChosen = true;
    for(int i = 0; i < point; i++) {
      _listQuestion[index].list_answers[i].isChosen = true;
    }
  }

  void _unChosen(int index) {
    _listQuestion[index].list_answers.forEach((answer) {
      answer.isChosen = false;
    });
  }

  int _numOfChosen(int index) {
    int result = 0;
    _listQuestion[index].list_answers.forEach((answer) {
      if(answer.isChosen) {
        result++;
      }
    });
    return result;
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

  bool _isNext2(int index) {
    bool check = false;
    _listQuestion[index].list_answers.forEach((answer) {
      if(answer.isChosen) {
        check = true;
      }
    });
    return check;
  }

  String getDescript(int point) {
    String descript = "";
    if(point == 1) {
      descript = "1★ - Strongly dislike";
    } else if(point == 2) {
      descript = "2★ - Dislike";
    } else if(point == 3) {
      descript = "3★ - Neither like not dislike";
    } else if(point == 4) {
      descript = "4★ - Like";
    } else if(point == 5) {
      descript = "5★ - Strongly like";
    } else {
      descript = "Select one";
    }
    return descript;
  }
}


void displayDiSCGuide(BuildContext context, String test) {
  var arlertDialog = AlertDialog(
    title: Text('Guide'),
    content: test == "DiSC" ? Text('This test contains 28 groups of four statements. Answer honestly and spontaneously. It should take you only 5 to 10 minutes to complete.'
        '\n\n\t      * Study all the descriptions in each group of four'
        '\n\t     * Select the one description that you consider most like you'
        '\n\t     * Study the remaining three choices in the same group'
        '\n\t     * Select the one description you consider least like you')
                             : Text("To take the Holland Code career quiz, mark your interest in each activity shown. Do not worry about whether you have the skills or training to do an activity, or how much money you might make. Simply think about whether you would enjoy doing it or not."
        "\n\n 1★ - Strongly dislike"
        "\n 2★ - Dislike"
        "\n 3★ - Neither like not dislike"
        "\n 4★ - Like"
        "\n 5★ - Strongly like"),
    actions: <Widget>[
      RaisedButton(onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
          child: Text('OK',style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.deepPurpleAccent[400], textColor: Colors.white),
    ],
  );

  showDialog(
    context: context,
    builder: (context) => arlertDialog,
  );
}

