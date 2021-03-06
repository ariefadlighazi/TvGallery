//import 'dart:math';

import 'api_details_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latian_jsonparse/api_details_test.dart';
import 'package:latian_jsonparse/show_details.dart';

import 'api_details.dart';
import 'models/movie_list_model.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'TVGallery';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          future: ApiEngine().fetchMovieList(),
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

class ShowList extends StatefulWidget {
  final List<ListShow> shows;

  ShowList({Key key, this.shows}) : super(key: key);

  @override
  _ShowListState createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DetailShow detailShow;
  TextEditingController editingController = TextEditingController();

  // ignore: deprecated_member_use
  var items = List<dynamic>();
  //String search = "anD";
  void initState() {
    items.addAll(widget.shows);
    
    super.initState();
  }
  
void filterSearchResults(String query) {
    // ignore: deprecated_member_use
    List<dynamic> dummySearchList = List<dynamic>();
    //dummySearchList.addAll(widget.shows);
    if(query.isNotEmpty) {
      //List<ListShow> dummyListData = List<ListShow>();
      for (int i = 0; i < widget.shows.length; i++) {
        ListShow data = widget.shows[i];
        if (data.show.name.toLowerCase().contains(query.toLowerCase())) {
          dummySearchList.add(data);
        }
    }
      setState(() {
        items.clear();
        items.addAll(dummySearchList);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.shows);
      });
    }
  }

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
          padding: EdgeInsets.fromLTRB(5, 70, 5, 0),
          itemCount: items.length,
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  items[index]
                                                      .show
                                                      .image
                                                      .medium,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.network(
                                                        'https://i.ibb.co/2PD1gbH/Hnet-com-image.jpg',
                                                        fit: BoxFit.fill);
                                                  },
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
                                                            items[index]
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
                                                                items[index]
                                                                    .show
                                                                    .premiered,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0)),
                                                        items[index]
                                                                    .show
                                                                    .genre
                                                                    .toString() ==
                                                                "[]"
                                                            ? Text("")
                                                            : Container(
                                                                width: 150,
                                                                child: Text(
                                                                    items[index]
                                                                        .show
                                                                        .genre
                                                                        .toString(),
                                                                    maxLines: 2,
                                                                    //softWrap: false,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)),
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
                      padding: const EdgeInsets.only(bottom: 1, right: 2),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Details ",
                                  style: TextStyle(fontSize: 14)),
                              WidgetSpan(
                                  child: Icon(
                                Icons.info_outline,
                                size: 14,
                                color: Colors.white,
                              ))
                            ]),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.white30,
                            shadowColor: Colors.black,
                            shape: StadiumBorder(),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MovieDetail(
                                    int.parse(items[index].show.id))));
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }),
      Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextField(
          controller: editingController,
          onChanged: (value) {
                  filterSearchResults(value);
                },
          decoration: InputDecoration(
            //labelText: "Search",
            filled: true,
            fillColor: Colors.white,
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
          ),
        ),
      ),
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
