import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'api_repsonse.dart';
import 'details_block.dart';
import 'package:flutter/material.dart';
import 'api_details.dart';
import 'dart:ui' as ui;

class MovieDetail extends StatefulWidget {
  final int selectedMovie;
  const MovieDetail(this.selectedMovie);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  MovieDetailBloc _movieDetailBloc;

  @override
  void initState() {
    super.initState();
    _movieDetailBloc = MovieDetailBloc(widget.selectedMovie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Details',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            _movieDetailBloc.fetchMovieDetail(widget.selectedMovie),
        child: StreamBuilder<ApiResponse<DetailShow>>(
          stream: _movieDetailBloc.movieDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ShowMovieDetail(displayMovie: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () =>
                        _movieDetailBloc.fetchMovieDetail(widget.selectedMovie),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _movieDetailBloc.dispose();
    super.dispose();
  }
}

class ShowMovieDetail extends StatefulWidget {
  final DetailShow displayMovie;

  ShowMovieDetail({Key key, this.displayMovie}) : super(key: key);

  @override
  _ShowMovieDetailState createState() => _ShowMovieDetailState();
}

class _ShowMovieDetailState extends State<ShowMovieDetail> {
  void _shareContent() {
    Share.share('Check this out!: ' + widget.displayMovie.url.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Image.network(
          widget.displayMovie.showImage.original.toString(),
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 400.0,
                    height: 400.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: NetworkImage(
                            widget.displayMovie.showImage.original.toString()),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(blurRadius: 20.0, offset: Offset(0.0, 10.0))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        widget.displayMovie.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      )),
                      Text(
                        widget.displayMovie.rating.rating.toString() == "null"
                            ? "**" + "/10"
                            : widget.displayMovie.rating.rating.toString() +
                                "/10",
//                      '${widget.movie['vote_average']}/10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      //Text(displayMovie.genre.toString())
                    ],
                  ),
                ),
                Html(
                  data: widget.displayMovie.summary,
                  style: {
                    "body": Style(
                      fontSize: FontSize(18.0),
                      color: Colors.white,
                    ),
                  },
                ),
                Padding(padding: const EdgeInsets.all(10.0)),
                Center(
                  child: widget.displayMovie.embedded.cast.length == 0
                      ? Column()
                      : Column(
                          children: <Widget>[
                            Text(
                              "CASTS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36.0,
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(10.0)),
                            SizedBox(
                              height: 260,
                              child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.displayMovie.embedded.cast.length,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 260,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 1.0,
                                  ),
                                  itemBuilder: (context, index) => Container(
                                        //color: Colors.amber,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "Tapped ${widget.displayMovie.embedded.cast[index].person.name}");
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: widget
                                                                  .displayMovie
                                                                  .embedded
                                                                  .cast[index]
                                                                  .person
                                                                  .image
                                                                  .medium ==
                                                              null
                                                          ? Image.network(
                                                              'https://i.ibb.co/2PD1gbH/Hnet-com-image.jpg',
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(widget
                                                              .displayMovie
                                                              .embedded
                                                              .cast[index]
                                                              .person
                                                              .image
                                                              .medium
                                                              .toString()),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                widget.displayMovie.embedded
                                                    .cast[index].person.name,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                overflow: TextOverflow.fade,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                            ),
                          ],
                        ),
                ),
                Padding(padding: const EdgeInsets.all(10.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: _shareContent,
                          icon: Icon(Icons.share),
                          label: Text('Share'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xaa3C3261),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.link),
                              color: Colors.white,
                              onPressed: () async {
                                final url =
                                    widget.displayMovie.officialSite == null
                                        ? widget.displayMovie.officialSite
                                        : widget.displayMovie.url;
                                if (await canLaunch(url)) {
                                  await launch(url, forceWebView: true);
                                } else {
                                  print("couldn't launch $url");
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xaa3C3261)),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

clicked(int index) {
  DetailShow imageCast;
  print("Tapped ${imageCast.embedded.cast[index].person}");
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              'Retry',
              style: TextStyle(
//                color: Colors.white,
                  ),
            ),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}
