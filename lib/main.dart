import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter_app/session.dart';
import 'MyChats.dart';
import 'config.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _username;
  String _password;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autovalidate = false;

  void _submit() {
    final curForm = formKey.currentState;

    if(curForm.validate()) {
      curForm.save();
      performLogin();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  void performLogin() {
//    final snackbar = new SnackBar(content: new Text("Username: $_username, Password: $_password"),);
//    scaffoldKey.currentState.showSnackBar(snackbar);

    Session session = new Session();
    final String url = addr+"LoginServlet";
    session.post(url, {
      "userid" : _username,
      "password" : _password
    }).then((val) {
      var resp = jsonDecode(val);
      print(val);
      if(resp['status'] == true){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyChatPage(_username, _password)
        ));
      } else {
        loginError();
      }
    });
  }

  void loginError() {
    final snackbar = new SnackBar(content: new Text("Login failed"));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Padding(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          autovalidate: _autovalidate,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextFormField(
                autofocus: true,
                decoration: new InputDecoration(labelText: "Username"),
                validator: (val) => val.isEmpty ? 'Username is empty' : null,
                onSaved: (val) => _username = val,
              ),
              new TextFormField(
                autofocus: false,
                decoration: new InputDecoration(labelText: "Password"),
                onSaved: (val) => _password = val,
              ),
              new Padding(padding: const EdgeInsets.only(top: 30.0),),
              new RaisedButton(
                child: new Text("submit"),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: new Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
