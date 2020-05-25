import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'APIからリスト表示',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get('https://next.json-generator.com/api/json/get/4y1iUv1ou');

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(
          u["index"],
          u["about"],
          u["picture"],
          u["age"],
          u["eyeColor"],
          Name(u["name"]["first"], u["name"]["last"]),
          u["company"],
          u["email"],
          u["phone"]);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var aData = snapshot.data[index];
                  var name = aData.name.first + ' ' + aData.name.last;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(aData.picture),
                    ),
                    title: Text(name),
                    subtitle: Text(aData.email),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => DetailPage(aData)));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name.first + ' ' + user.name.last),
      ),
      body: Center(
        child: Flexible(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Text(user.company),
                Text(user.about),
                Text(user.eyeColor),
                Text(user.email),
                Text(user.phone)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class User {
  final int index;
  final String about;
  final String picture;
  final int age;
  final String eyeColor;
  final Name name;
  final String company;
  final String email;
  final String phone;

  User(this.index, this.about, this.picture, this.age, this.eyeColor, this.name,
      this.company, this.email, this.phone);
}

class Name {
  final String first;
  final String last;
  Name(this.first, this.last);
}
