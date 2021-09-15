import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_details.dart';
import 'models/movie_list_model.dart';

class ApiEngine {
  String _url = "https://api.tvmaze.com/schedule?country=US";
  Dio _dio;

  ApiEngine() {
    _dio = Dio();
  }

  Future<List<ListShow>> fetchMovieList() async {
    try {
      //Response response = await _dio.get(_url);
      Response<String> response = await _dio.get(_url);
      String body = response.data.toString();
      //var values = jsonDecode(body);
      List<ListShow> movieList = parseList(body);
      //List<ListShow> listMovie = movieList as List<ListShow>;
      return movieList;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<DetailShow> fetchMovieDetail(String id) async {
    try {
      String apiURL = "http://api.tvmaze.com/shows/" + id + "?embed=cast";
      Response response = await _dio.get(apiURL);
      //String body = response.data.toString();

      //DetailShow movieDetail = parseDetailList(body);
      DetailShow movieDetail = DetailShow.fromJson(response.data);
      //var apiResult = await http.get(Uri.parse(apiURL));
      //var jsonObject = json.decode(apiResult.body);

      return movieDetail;
    } on DioError catch (e) {
      print(e);
    }
  }
}
