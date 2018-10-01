import 'package:flutter/material.dart';

import 'package:flutter_app/session.dart';
import 'dart:convert';
import 'config.dart';

class MyChatDetail extends StatefulWidget {
  MyChatDetail(this._username, this._password, this._otherid);
  final String _username;
  final String _password;
  final String _otherid;
  String _othername;
  @override
  _MyChatDetailState createState() => new _MyChatDetailState(_username, _password, _otherid);
}

class _MyChatDetailState extends State<MyChatDetail> {
  _MyChatDetailState(this._username, this._password, this._otherid);
  final String _username;
  final String _password;
  final String _otherid;

  String _othername = "";

  var body;
  Map<String, dynamic> json= {};
  List<dynamic> data = [];

  void refresh() {
    Session session = new Session();
    final String url = addr+"ConversationDetail";
    session.post(url, {
      "other_id" : _otherid
    }).then((val) {
      print(val);
//      loadconv(val);
    });
  }

  @override
  void initState() {
    body = new Padding(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      padding: const EdgeInsets.all(20.0),
      child: Text("Welcome to the chat with " + _otherid),
    );
//    Map<String, dynamic> acjson;
//    List<dynamic> data = [];
//    Session session = new Session();
//    String url = addr+"AllConversations";
//    session.get(url).then((val) {
//      acjson = jsonDecode(val);
//      data = acjson['data'];
//      for(int i = 0; i < data.length; i){
//        if(data[i]["id"].toString() == _otherid)
//          _othername = data[i]["name"].toString();
//      }
//    });
    super.initState();
    refresh();
  }

  void loadconv(String content){
    json = jsonDecode(content);
    data = json["data"];
    setState(() {
      body = new ListView.builder(
        itemCount: data == null ? 0 : data.length*2,
        itemBuilder: (BuildContext context, int index) {
          if(index.isOdd) return new Divider();
          String timestamp = data[index~/2]["last_timestamp"].toString();
//          String _otherid = data[index~/2]["uid"].toString();
          return new ListTile(
            title: Text(data[index~/2]["uid"]),
            trailing: timestamp == null ? Text("") : Text(timestamp),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(_othername),
        actions: <Widget>[
        ],
      ),
//      body: body,
        body: new Builder(builder: (BuildContext scaffoldContext){
          return new Column(
            children: <Widget>[
              new Container(
                height: 200.0,
                child: body,
              ),
              SizedBox(height: 10.0),
              new Expanded(
                child: new TextField(
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder()
                  ),
                ),
              ),
            ],
          );
        })
    );
  }
}