import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nested_listview/Video.dart';
import 'package:nested_listview/model.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Video Player'),
          ),
          body: CustomList()),
    );
  }
}

class CustomList extends StatefulWidget {
  final String title;

  CustomList({Key key, this.title}) : super(key: key);

  @override
  _CustomListState createState() => new _CustomListState();
}

class _CustomListState extends State<CustomList> {
  var videoPlayerController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Center(
          child: FutureBuilder(
              future: fetchCourse(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  print("------");
                  print(snapshot.data[0].lecture);
                  return SizedBox(
                    height: screenHeight,
                    child: ListView.builder(
                      // ignore: non_constant_identifier_names
                      itemBuilder: (context, Chapterindex) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.local_play_outlined),
                                title: Text(
                                  snapshot.data[Chapterindex].title,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                //title: Text('$index',textAlign: TextAlign.center,),
                                trailing: Text(
                                  "Total Lecture " +
                                      snapshot.data[Chapterindex].items
                                          .toString(),
                                  style: TextStyle(fontSize: 14.0),
                                ),

                                //shape: Theme.of(context).textTheme.body2,
                              ),
                              Card(
                                child: ListView.builder(
                                  // ignore: missing_return, non_constant_identifier_names
                                  itemBuilder: (context, Lectureindex) {
                                    return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.0,
                                          vertical: 1.0,
                                        ),
                                        child: ListTile(
                                          leading: Icon(Icons.play_circle_fill),
                                          title: Text(
                                              snapshot.data[Chapterindex]
                                                  .lecture[Lectureindex].title,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold)),
                                          trailing: Wrap(
                                            spacing: 12,
                                            // space between two icons
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.download_sharp),
                                                onPressed: () {
                                                  setState(() {
                                                    downloadFile(snapshot
                                                        .data[Chapterindex]
                                                        .lecture[Lectureindex]
                                                        .file
                                                        );
                                                  });
                                                },
                                              ),
                                              // icon-1
                                              Icon(Icons.share),
                                              // icon-2
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              String data = snapshot
                                                  .data[Chapterindex]
                                                  .lecture[Lectureindex]
                                                  .file;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyVideoplayer(
                                                            videoData: data,
                                                          )));
                                            });
                                            print(snapshot.data[Chapterindex]
                                                .lecture[Lectureindex].file);
                                          },
                                        )
                                        //Padding(padding:EdgeInsets.only(left:650)),
                                        // Icon(Icons.download_sharp),
                                        // Icon(Icons.share)
                                        );
                                  },
                                  itemCount: snapshot
                                      .data[Chapterindex].lecture.length,
                                  shrinkWrap: true,
                                  // todo comment this out and check the result
                                  physics:
                                      ClampingScrollPhysics(), // todo comment this out and check the result
                                ),
                                elevation: 8,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data.length,
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }

  Future<List<Chapter>> fetchCourse() async {
    final response =
        await http.get("https://rkmhikai.online/ClassRoom/cache/CLAI.cache");

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      //print(jsonData);
      // var courses = (jsonData['records']);
      //print(courses);

      List<Chapter> chapterList = [];
      var i;
      for (var data in jsonData) {
        // print(data);

        // print(data["chapterNo"]);
        // print(data["title"]);
        // print(data["ebook"]);
        // print(data["items"]);

        List<Lecture> lectureList = [];
        for (i = 0; i < data["items"]; i++) {
          var dataLecture = data["lecture"][i];
          //print(dataLecture["title"]);
          Lecture lecture = Lecture(
              id: dataLecture["id"],
              lectureId: dataLecture["lectureId"],
              content: dataLecture["content"],
              title: dataLecture["title"],
              file: dataLecture["file"],
              description: dataLecture["description"]);
          lectureList.add(lecture);
        }

        Chapter chapter = Chapter(
            chapterNo: data["chapterNo"],
            title: data["title"],
            ebook: data["ebook"],
            items: data["items"],
            lecture: lectureList);
        chapterList.add(chapter);
      }
      return chapterList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> downloadFile(String videourl) async {
    print("inside download");
    bool downloading = false;
    var progressString = "";

    Dio dio = Dio();

    try {

      var dir = await getApplicationDocumentsDirectory();
      print(dir.path);

      await dio.download(videourl, "${dir.path}/myimage.jpg",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          print(progressString);
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      // progressString = "Completed";
    });
    print("Download completed");
  }
}
