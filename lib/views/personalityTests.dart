import 'package:demologingg/dependency/presenter/MainPresenter.dart';
import 'package:demologingg/data/PersonalityTest.dart';
import 'package:demologingg/sign_in.dart';
import 'package:demologingg/views/login_page.dart';
import 'package:demologingg/views/quiz_page.dart';
import 'package:flutter/material.dart';

class PersonalityTests extends StatefulWidget {
  @override
  __PersonalityTestsState createState() => new __PersonalityTestsState();
}

class __PersonalityTestsState extends State<PersonalityTests> implements PersonalityTestListViewContract {
  PersonalityTestPresenter _presenter;
  List<PersonalityTest> personalityTests;
  bool _isLoading;

  __PersonalityTestsState() {
    _presenter = new PersonalityTestPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadPersonalityTest();
    //getPersonalityTests();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent[400],
          title: new Text("Personality Test"),
          leading: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _showPopupMenu,
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 55,
              ),
            ),
            //CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: personalityTests == null ? Center(child: Text('Empty'),)
              : ListView.builder(itemCount: personalityTests.length,itemBuilder: (context, index) {
            return Card(clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(aspectRatio: 18.0 / 11.0, child: Image.network( personalityTests[index].image, height: 200)),
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        role == "Admin" ?
                        RaisedButton(onPressed: (){}, child: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.deepPurpleAccent[400], textColor: Colors.white) :
                        SizedBox(width: 0),
                        SizedBox(width: 12),
                        RaisedButton(
                            onPressed: () { displayInformation(context, personalityTests[index]);},
                            child: Text('Information',style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.deepPurpleAccent[400], textColor: Colors.white
                        ),
                        SizedBox(width: 12),
                        RaisedButton(onPressed: () {displayGuide(context, personalityTests[index]);}, child: Text('Test Now',style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.deepPurpleAccent[400], textColor: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          ),
        ),
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
      builder: (context) => arlertDialog,
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 80, 100, 100),
      items: [
        PopupMenuItem(
          child: Text("View History"),
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

  @override
  void onSccess(List<PersonalityTest> items) {
    setState(() {
      _isLoading = false;
      personalityTests = items;
    });
  }

  void displyGuide(BuildContext context, PersonalityTest perTest) {
    var arlertDialog = AlertDialog(
      title: Text("GUIDE INFORMATION"),
      content: Text("Remenber: "
          "\nThere are no right answers to any of these questions. "
          "\nAnswer the questions quickly, do not over-analyze them. Some seem wordedpoorly. Go with what feels best. "),
      actions: <Widget>[
        RaisedButton(onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(perTest: perTest,)));
        },
            child: Text('START',style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.deepPurpleAccent[400], textColor: Colors.white),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => arlertDialog,
    );
  }

  @override
  void onSuccess(List<PersonalityTest> items) {
    setState(() {
      _isLoading = false;
      personalityTests = items;
    });
  }

  void displayGuide(BuildContext context, PersonalityTest perTest) {
    var arlertDialog = AlertDialog(
      title: Text("GUIDE INFORMATION"),
      content: Text("Remenber: "
          "\nThere are no right answers to any of these questions. "
          "\nAnswer the questions quickly, do not over-analyze them. Some seem wordedpoorly. Go with what feels best. "),
      actions: <Widget>[
        RaisedButton(onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(perTest: perTest,)));
        },
            child: Text('START',style: TextStyle(fontWeight: FontWeight.bold)), color: Colors.deepPurpleAccent[400], textColor: Colors.white),
      ],
    );

    showDialog(
      context: context,
      builder: (context) => arlertDialog,
    );
  }
}
