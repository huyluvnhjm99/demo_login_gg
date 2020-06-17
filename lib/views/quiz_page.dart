import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/data/Question.dart';
import 'package:demologingg/dependency/presenter/MainPresenter.dart';
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
  bool _isLoading;

  _QuizPageState() {
    _presenter = new QuestionPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadQuestionList(widget.perTest.id);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[400],
          title: new Text(widget.perTest.type),
          leading: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(onTap: _showPopupMenu,child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),radius: 55,),),
          ),
        ),
        body: _listQuestion == null ? Center(child: Text('Empty')) :
        ListView.builder(itemCount: _listQuestion.length,itemBuilder: (context, index) {
          return Card(clipBehavior: Clip.antiAlias,
            margin: index == 0 ? EdgeInsets.fromLTRB(35, 15, 35, 0) : EdgeInsets.fromLTRB(35, 15, 35, 0),
            child: Padding(padding: EdgeInsets.fromLTRB(30, 45, 30, 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Question ' + (index + 1).toString() + ': ' + _listQuestion[index].question_content),
                  Text('Answer 1'),
                  Text('Answer 2'),
                ],
              ),
            )
          );
        }),
      ),
      onWillPop: _onWillPop,
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 80, 100, 100),
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

  @override
  void onSuccess(List<Question> questionList) {
    setState(() {
      _isLoading = false;
      _listQuestion = questionList;
    });
  }
}