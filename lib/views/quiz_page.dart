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
            : widget.perTest.type == 'DiSC profile' ?
        PageView.builder(itemCount: (_listQuestion.length / 4).toInt(), itemBuilder: (context, index) {
          return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.fromLTRB(30, 50, 30, 85),
              child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                              _listQuestion[index * 4 + 0].list_answers.last.isChosen = false;
                              setState(() {});
                            },
                            iconSize: 40,
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
                            iconSize: 40,
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
                          iconSize: 40,
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
                          iconSize: 40,
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
                          iconSize: 40,
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
                          iconSize: 40,
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
                          iconSize: 40,
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
                          iconSize: 40,
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
        }, controller: pageController, physics: NeverScrollableScrollPhysics())
            : PageView.builder(itemCount: _listQuestion.length,itemBuilder: (context, index) {
          return Card(clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.fromLTRB(30, 50, 30, 85),
              child: Padding(padding: EdgeInsets.fromLTRB(20, 4, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:EdgeInsets.fromLTRB(280, 0, 0, 5),
                      child: IconButton(icon: Icon(Icons.info), onPressed: () {
                        displayDiSCGuide(context, "HOLLAND");
                      }),
                    ),
                    Text('Q.' + (index + 1).toString() + ': ' + _listQuestion[index].question_content, style: TextStyle(fontSize: 22)),
                    SizedBox(height: 10),
                    //1111111111111111111
                    OutlineButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                        _unChosen(index);
                        _setChosen(index, 1);
                        setState(() {_isDone = isDone();});
                      },
                      splashColor: Colors.deepPurpleAccent[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Container(
                          width: 1000,
                          padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                          child: Text("Strongly Dislike", style: TextStyle(fontSize: 15),)
                      ),
                    ),
                    //2222222222222222222
                    SizedBox(height: 4),
                    OutlineButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                        _unChosen(index);
                        _setChosen(index, 2);
                        setState(() {_isDone = isDone();});
                      },
                      splashColor: Colors.deepPurpleAccent[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Container(
                          width: 1000,
                          padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                          child: Text("Dislike", style: TextStyle(fontSize: 15),)
                      ),
                    ),
                    //33333333333333333
                    SizedBox(height: 4),
                    OutlineButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                        _unChosen(index);
                        _setChosen(index, 3);
                        setState(() {_isDone = isDone();});
                      },
                      splashColor: Colors.deepPurpleAccent[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Container(
                          width: 1000,
                          padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                          child: Text("Neither Like not Dislike", style: TextStyle(fontSize: 15),)
                      ),
                    ),
                    //444444444444444444
                    SizedBox(height: 4),
                    OutlineButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                        _unChosen(index);
                        _setChosen(index, 4);
                        setState(() {_isDone = isDone();});
                      },
                      splashColor: Colors.deepPurpleAccent[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Container(
                          width: 1000,
                          padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                          child: Text("Like", style: TextStyle(fontSize: 15),)
                      ),
                    ),
                    //55555555555555555
                    SizedBox(height: 4),
                    OutlineButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                        _unChosen(index);
                        _setChosen(index, 5);
                        setState(() {_isDone = isDone();});
                      },
                      splashColor: Colors.deepPurpleAccent[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Container(
                          width: 1000,
                          padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                          child: Text("Strongly Like", style: TextStyle(fontSize: 15),)
                      ),
                    ),

                    _isDone == true ? Container(
                      margin: EdgeInsets.only(left: 110, top: 5),
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

void displayDiSCGuide(BuildContext context, String test) {
  var arlertDialog = AlertDialog(
    title: Text('Guide'),
    content: test == "DiSC" ? Text('This test contains 28 groups of four statements. Answer honestly and spontaneously. It should take you only 5 to 10 minutes to complete.'
        '\n\n\t      * Study all the descriptions in each group of four'
        '\n\t     * Select the one description that you consider most like you'
        '\n\t     * Study the remaining three choices in the same group'
        '\n\t     * Select the one description you consider least like you')
                             : Text("To take the Holland Code career quiz, mark your interest in each activity shown. Do not worry about whether you have the skills or training to do an activity, or how much money you might make. Simply think about whether you would enjoy doing it or not."),
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

