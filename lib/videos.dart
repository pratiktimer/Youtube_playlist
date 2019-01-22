import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_youtube/flutter_youtube.dart';

class Videos extends StatefulWidget {
  final id;
  Videos(this.id);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Videos> {
  var videos;
  bool _isLoading = true;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    var id2 = widget.id;
    var channelurl =
        "https://sheltered-ridge-50029.herokuapp.com/youtube/video/playlist/$id2";
    final response = await http.get(channelurl);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosjson = map["items"];
      if (this.mounted) {
        setState(() {
          this.videos = videosjson;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchData();
    return Scaffold(
        body: Container(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: this.videos != null ? this.videos.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      final id = videos[index]['contentDetails']['videoId'];
                      return FlatButton(
                          onPressed: () {
                            FlutterYoutube.playYoutubeVideoById(
                                apiKey:
                                    "put here api key",//dont forget to put key here
                                videoId: id,
                                autoPlay: true, //default falase
                                fullScreen: true //default false
                                );
                          },
                          child: Column(
                            children: <Widget>[
                              FadeInImage(
                                  image: NetworkImage(videos[index]["snippet"]
                                      ["thumbnails"]["maxres"]["url"]),
                                  placeholder: AssetImage("images/q.jpeg"),
                                  fit: BoxFit.cover),
                              Text(
                                videos[index]["snippet"]["title"],
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ));
                    },
                  )));
  }
}
