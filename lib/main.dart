import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youtubeclone/videos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Youtube Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String rec="";
  var videos;
  bool _isLoading = true;
  var channelurl =
      "https://sheltered-ridge-50029.herokuapp.com/youtube/channel/UCC89oVFqenaffhBoyqxd6qw";
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    final response = await http.get(channelurl);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosjson = map["items"];
      setState(() {
        this.videos = videosjson;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: this.videos != null ? this.videos.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      final video = this.videos[index];
                      final id = videos[index]["id"];
                      if(video.toString().contains("maxres")){
                        rec="maxres";
                      }
                      else if(video.toString().contains("high")){
                        rec="high";
                      }
                      else if(video.toString().contains("medium")){
                        rec="medium";
                      }
                      if (rec!="") {
                        return FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Videos(id)));
                            },
                            child: Column(
                              children: <Widget>[
                                FadeInImage(
                                    image: NetworkImage(video['snippet']['thumbnails'][rec]['url']),
                                    placeholder: AssetImage("images/q.jpeg"),
                                    fit: BoxFit.cover),
                                Text(
                                  videos[index]["snippet"]["title"],
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ));
                      }
                      else{
                        return Text("");
                      }
                    },
                  )));
  }
}
