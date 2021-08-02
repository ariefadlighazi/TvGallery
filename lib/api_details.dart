import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailShow {
  final String name, type, language, premiered, officialSite, summary, url;
  final ShowImage showImage;
  final Rating rating;
  //final List<String> genre;
  DetailShow(
      { this.name,
       this.type,
       this.language,
      this.summary,
      this.officialSite,
      this.premiered,
      this.showImage,
      this.rating,
      this.url,
      /*required this.genre*/});

  factory DetailShow.fromJson(Map<String, dynamic> parsedJson) {
    //var genreFromJson = parsedJson['genre'];
    //List<String> genreList = genreFromJson.cast<String>();

    return new DetailShow(
        name: parsedJson['name'],
        type: parsedJson['type'],
        language: parsedJson['language'],
        summary: parsedJson['summary'],
        officialSite: parsedJson['officialSite'],
        premiered: parsedJson['premiered'],
        rating: Rating?.fromJson(parsedJson['rating']),
        url: parsedJson['url'],
        showImage: ShowImage?.fromJson(parsedJson['image'] ??= parsedJson['network'])
        /*genre: genreList*/);
  }

  static Future<DetailShow> connectToAPI(String id) async
  {
    String apiURL = "http://api.tvmaze.com/shows/" + id;

    var apiResult = await http.get(Uri.parse(apiURL));
    var jsonObject = json.decode(apiResult.body);
    
    //var showDetail = (jsonObject as Map<String, dynamic>)

    return DetailShow.fromJson(jsonObject);
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

class Rating{
  final double rating;

  Rating({this.rating});

  factory Rating.fromJson(Map<String, dynamic> object) {
    return Rating(rating: object['average']);
  }
}

mixin required {
}
