import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'ChatDetail.dart';
import 'package:flutter_app/session.dart';
import 'dart:convert';
import 'config.dart';

class MyCreatePage extends StatefulWidget {
  MyCreatePage(this._username, this._password);
  final String _username;
  final String _password;
  final String title = "Create Conversations";
  @override
  _MyCreatePageState createState() => new _MyCreatePageState(_username, _password);
}

class _MyCreatePageState extends State<MyCreatePage> {
  _MyCreatePageState(this._username, this._password);

  final String _username;
  final String _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  )
              ),
              suggestionsCallback: (pattern) async {
                Session session = new Session();
                final String url = addr+"AutoCompleteUser?term="+pattern;
                var val = await session.get(url);
                print(val);
                List<dynamic> data = jsonDecode(val);
                return data;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['label']),
//                  subtitle: Text(suggestion['value']),
                );
              },
              onSuggestionSelected: (suggestion) {
                Map<String, dynamic> acjson;
                List<dynamic> data = [];
                Session session = new Session();
                String url = addr+"AllConversations";
                session.get(url).then((val) {
                  acjson = jsonDecode(val);
                  data = acjson['data'];
                  int conv_exists = 0;
                  for(int i = 0; i < data.length; i++){
                    if(data[i]['uid'] == suggestion['value']) conv_exists = 1;
                  }
                  if(conv_exists == 1){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MyChatDetail(_username, _password, suggestion['value'])
                    ));
                  } else {
                    Session session = new Session();
                    String url = addr+"CreateConversation?other_id="+suggestion['value'];
                    session.get(url).then((value) {
                      print(val);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyChatDetail(_username, _password, suggestion['value'])
                      ));
                    });
                  }
                });
              },
            )
          ],
        )
      ),
    );
  }
}