import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _url;

  void initialUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _url = preferences.getString('kUrl') ?? 'Please set URL';
  }

  @override
  void initState() {
    super.initState();
    initialUrl();
  }

  Future<void> _onChange(String text) async {
    setState(() {
      _url = text + '/predict';
    });
  }

  Future<String> accessUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = preferences.getString('kUrl') ?? 'Please set URL';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Vision Assistant'),
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  _inputSection(),
                  _btnSection(),
                  SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<String>(
                        future: accessUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done)
                            return Text(
                              'URL is currently set to : ${snapshot.data}',
                              style: TextStyle(fontSize: 20),
                            );
                          else
                            return CircularProgressIndicator();
                        }),
                  ),
                ]))));
  }

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: TextField(
        onChanged: (String value) {
          _onChange(value);
        },
      ));
  Widget _btnSection() {
    return Container(
      padding: EdgeInsets.all(50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Theme.of(context).accentColor,
            elevation: 6,
            child: InkWell(
              splashColor: Colors.grey.withAlpha(30),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.setString('kUrl', _url);
                setState(() {
                  Fluttertoast.showToast(
                    msg: "Url set to $_url",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                height: 50.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'SET URL',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      ),
                    ]),
              ),
            ),
          ),
          SizedBox(height: 18.0),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Theme.of(context).accentColor,
            elevation: 6,
            child: InkWell(
              splashColor: Colors.grey.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, "/camera");
              },
              child: Container(
                padding: EdgeInsets.all(10),
                height: 50.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'OPEN CAMERA',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
