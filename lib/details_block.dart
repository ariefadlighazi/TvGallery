import 'dart:async';
import 'api_repsonse.dart';
import 'api_details.dart';
import 'api_details_test.dart';

class MovieDetailBloc {


  StreamController _movieDetailController;

  StreamSink<ApiResponse<DetailShow>> get movieDetailSink =>
      _movieDetailController.sink;

  Stream<ApiResponse<DetailShow>> get movieDetailStream =>
      _movieDetailController.stream;

  MovieDetailBloc(selectedMovie) {
    _movieDetailController = StreamController<ApiResponse<DetailShow>>();
    fetchMovieDetail(selectedMovie);
  }

  fetchMovieDetail(int selectedMovie) async {
    movieDetailSink.add(ApiResponse.loading('Loading'));
    try {
      DetailShow details =
          await ApiEngine().fetchMovieDetail(selectedMovie.toString());
      movieDetailSink.add(ApiResponse.completed(details));
    } catch (e) {  
      movieDetailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _movieDetailController?.close();
  }
}
