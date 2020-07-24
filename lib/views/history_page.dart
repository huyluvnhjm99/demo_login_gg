

import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/data/Result.dart';
import 'package:demologingg/dependency/presenter/MainPresenter.dart';
import 'package:demologingg/views/login_page.dart';
import 'package:demologingg/views/personalityTests.dart';
import 'package:flutter/material.dart';
import 'package:demologingg/sign_in.dart';

class HistoryPage extends StatefulWidget {
  final List<PersonalityTest> listPerTest;

  HistoryPage({Key key, @required this.listPerTest}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new __HistoryPageState();
  }

}

class __HistoryPageState extends State<HistoryPage> implements ResultView {
  ResultPresenter _presenter;
  List<Result> _resultList;
  bool _isLoading;

  __HistoryPageState() {
    _presenter = new ResultPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadResultList(email);
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
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
          body: _resultList == null ? Center(child: Text('Loading...'))
              : ListView.builder(itemCount: _resultList.length,itemBuilder: (context, index) {
            return Card(clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: Row(children: <Widget>[
                      Image.network(_findTestImageLink(_resultList[index].test_name), height: 100, width: 200,),
                      Column(
                        children: <Widget>[
                          Text("Test: " + _resultList[index].test_name),
                          Text("Date: " + _resultList[index].date_create.day.toString() + "/"
                              + _resultList[index].date_create.month.toString() + "/" + _resultList[index].date_create.year.toString()),
                          Text("Result: " + _resultList[index].personality, style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      )
                    ],),
                  )
                ],
              ),
            );
          },
          ),
        ),
        onWillPop: _onWillPop
    );
  }

  @override
  void onSuccesss(List<Result> resultList) {
    setState(() {
      _isLoading = false;
      _resultList = resultList;
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

  String _findTestImageLink(String testType) {
    String link = "";
    widget.listPerTest.forEach((test) {
      if(test.type.compareTo(testType) == 0) {
        link = test.image;
      }
    });
    return link;
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

}