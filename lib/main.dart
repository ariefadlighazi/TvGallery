import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latian_jsonparse/show_details.dart';

import 'api_details.dart';


Future<List<ListShow>> fetchList(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://api.tvmaze.com/schedule'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseList, response.body);
}

// A function that converts a response body into a List<Photo>.
List<ListShow> parseList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ListShow>((object) => ListShow.fromJson(object)).toList();
}

class ListShow {
  final String score;
  final Show show;

  ListShow({this.score, this.show});

  factory ListShow.fromJson(Map<String, dynamic> object) {
    return ListShow(
      score: object['score'].toString(),
      show: Show.fromJson(object['show']),
    );
  }
}

class Show {
  final String id;
  final String name;
  final String premiered;
  //String medium;
  ShowImage image;

  Show({
    this.id,
    this.name,
    this.premiered,
    this.image,
    /*this.medium*/
  });

  factory Show.fromJson(Map<String, dynamic> object) {
    print(object['image']);
    return Show(
        id: object['id'].toString(),
        name: object['name'] == null ? "" : object['name'] as String,
        premiered:
            object['premiered'] == null ? "" : object['premiered'] as String,
        //medium: object['medium'],
        image: ShowImage?.fromJson(object['image'] ??= object['network']));
  }
}

class ShowImage {
  final String medium;
  final String original;

  ShowImage({this.medium, this.original});

  factory ShowImage.fromJson(Map<String, dynamic> object) {
    //print(object);
    return ShowImage(
      medium: object['medium'] == null ? "" : object['medium'],
      original: object['original'] == null ? "" : object['original'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'TVGallery';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TV SHOW GALERY",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(children: [
        FutureBuilder<List<ListShow>>(
          future: fetchList(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ShowList(shows: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ]),
    );
  }
}

class ShowList extends StatelessWidget {
  final List<ListShow> shows;
  DetailShow detailShow;

  ShowList({Key key, this.shows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black54, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
      ),
      ListView.builder(
          itemCount: shows.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: 220,
              width: double.maxFinite,
              child: Card(
                color: Colors.black45,
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              //color: Colors.white,
                                              width: 140,
                                              height: 150,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image(
                                                  image: NetworkImage(shows[index]
                                                      .show
                                                      .image
                                                      .medium),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          height: 75,
                                                          child: Text(
                                                            shows[index]
                                                                .show
                                                                .name
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 24),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Text(
                                                            "Premiered: " +
                                                                shows[index]
                                                                    .show
                                                                    .premiered,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        Text(
                                                            "Show ID: " +
                                                                shows[index]
                                                                    .show
                                                                    .id,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: RichText(text: TextSpan(
                            children: [
                              TextSpan(text: "Details ", style: TextStyle(fontSize: 20)),
                              WidgetSpan(child: Icon(Icons.info_outline, size:20, color: Colors.white,))
                            ]
                          ),),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.white30,
                            shadowColor: Colors.black,
                            shape: StadiumBorder(),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MovieDetail(
                                    int.parse(shows[index].show.id))));
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }),
    ]);

    /*return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].show.);
      },
    );*/
  }
}
