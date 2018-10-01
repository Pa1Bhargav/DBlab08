import 'package:flutter/material.dart';
import 'package:flutter_app/CreateConversation.dart';
import 'package:flutter_app/ChatDetail.dart';

import 'package:flutter_app/session.dart';
import 'dart:io';
import 'dart:convert';
import 'config.dart';

class MyChatPage extends StatefulWidget {
  MyChatPage(this._username, this._password);
  final String _username;
  final String _password;
  final String title = "Chats";

  @override
  _MyChatPageState createState() => new _MyChatPageState(_username, _password);
}


class _MyChatPageState extends State<MyChatPage> {
  _MyChatPageState(this._username, this._password);
  final String _username;
  final String _password;
  String loadContent = "Loading ...";

  Map<String, dynamic> json= {};
  List<dynamic> data = [];

  List<dynamic> filteredData = [];

  var body;

  void refresh() async {
    setState(() {
      loadContent = "Loading ..";
      body = new Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(loadContent),
      );
    });
    Session session = new Session();
    String url = addr+"AllConversations";
    var val = await session.get(url);
    var dur = new Duration(seconds: 1);
    sleep(dur);
    print(val);
    loadconvs(val);
  }

  @override
  void initState() {
    body = new Padding(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      padding: const EdgeInsets.all(20.0),
      child: Text(loadContent),
    );

    super.initState();
    refresh();
  }

  void loadconvs(String content){
    json = jsonDecode(content);
    setState(() {
      data = json["data"];
      filteredData = data;
    });
    createListView();
  }

  void createListView() {
    setState(() {
      body = new ListView.builder(
        itemCount: filteredData == null ? 0 : filteredData.length*2,
        itemBuilder: (BuildContext context, int index) {
          if(index.isOdd) return new Divider();
          String timestamp = filteredData[index~/2]["last_timestamp"].toString();
//          String _othername= filteredData[index~/2]["name"].toString();
          String _otherid= filteredData[index~/2]["uid"].toString();
          return new ListTile(
            title: Text(filteredData[index~/2]["name"]),
            subtitle: Text(filteredData[index~/2]["uid"]),
            trailing: timestamp == "null" ? Text("") : Text(timestamp.substring(0, 19)),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  MyChatDetail(_username, _password, _otherid)));
            },
          );
        },
      );
    });
  }

  void _searchPressed(text) {
    if (!(text.isEmpty)) {
//      print(text);
      List tempList = new List();
      for (int i = 0; i < data.length; i++) {
        if (data[i]['uid'].toLowerCase().contains(text.toLowerCase()) || data[i]['name'].toLowerCase().contains(text.toLowerCase())) {
          tempList.add(data[i]);
        }
      }
//      print(tempList);
      setState(() {
        filteredData = tempList;
      });
      createListView();
    } else {
      setState(() {
        filteredData = data;
      });
      createListView();
    }
  }

  void create() {
//    runApp(MyCreatePage(_username, _password));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyCreatePage(_username, _password)
    )).then((val) {

    });
  }

  void logout() {
    Session session = new Session();
    final String url = addr+"LogoutServlet";
    session.get(url).then((val) {
      print(val);
      var resp = jsonDecode(val);
      if(resp["Status"] = true){
        Navigator.pop(context);
      } else {
        logout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        leading: IconButton(icon: Icon(Icons.home), onPressed: refresh),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.create), onPressed: create),
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: logout),
        ],
      ),
      body: new Builder(builder: (BuildContext scaffoldContext){
        return new Center(
          child: new Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              new TextField(
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: "Search...",
                  border: OutlineInputBorder()
                ),
                onChanged: (text) => _searchPressed(text),
              ),
              new Expanded(
                  child: new Container(
                    height: 200.0,
                    child: body,
                  ))
            ],
          ),
        );
      })
    );
  }

}

