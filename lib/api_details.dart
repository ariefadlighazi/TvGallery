import 'dart:convert';


Map<String, dynamic> jsonData = '{"medium": "https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg","original": "https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482953.jpg"}' as Map<String, dynamic>;

DetailShow parseDetailList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<DetailShow>((object) => DetailShow.fromJson(object));
}
class DetailShow {
  final String name, type, language, premiered, officialSite, summary, url;
  final ShowImage showImage;
  final Rating rating;
  final Embedded embedded;
  final List<String> genre;
  DetailShow(
      {this.name,
      this.type,
      this.language,
      this.summary,
      this.officialSite,
      this.premiered,
      this.showImage,
      this.rating,
      this.url,
      this.embedded,
      this.genre,
      /*required this.genre*/
      });

  factory DetailShow.fromJson(Map<String, dynamic> parsedJson) {
    //var genreFromJson = parsedJson['genre'];
    //List<String> genreList = genreFromJson.cast<String>();
    //var listOfCast = (parsedJson['_embedded'] as List).map((i) => Cast.fromJson(i));
    //print(parsedJson['_embedded']);
    /*var genreFromJson = parsedJson['genres'];
    List<String> genreList = genreFromJson.cast<String>();
    print(genreList);*/
    print(Embedded.fromJson(parsedJson['_embedded']));

    return new DetailShow(
        name: parsedJson['name'],
        type: parsedJson['type'],
        language: parsedJson['language'],
        summary: parsedJson['summary'] == null ? "" : parsedJson['summary'],
        officialSite: parsedJson['officialSite'],
        premiered: parsedJson['premiered'],
        rating: Rating?.fromJson(parsedJson['rating']),
        url: parsedJson['url'],
        showImage:
            ShowImage?.fromJson(parsedJson['image'] ??= parsedJson['network']),
        genre: List<String>.from(parsedJson['genres']),
        embedded: Embedded.fromJson(parsedJson['_embedded']),
        /*genre: genreList*/
        );
  }

  /*static Future<DetailShow> connectToAPI(String id) async {
    String apiURL = "http://api.tvmaze.com/shows/" + id + "?embed=cast";

    var apiResult = await http.get(Uri.parse(apiURL));
    var jsonObject = json.decode(apiResult.body);

    return DetailShow.fromJson(jsonObject);
  }*/
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


class Rating {
  final double rating;

  Rating({this.rating});

  factory Rating.fromJson(Map<String, dynamic> object) {
    return Rating(
        rating: object['average'] == null
            ? object['average']
            : object['average'].toDouble());
  }
}

class Embedded {
  List<Cast> cast;

  Embedded({this.cast});

  factory Embedded.fromJson(Map<String, dynamic> object) {
    Iterable<Cast> listOfCast;
    listOfCast = (object['cast'] as List).map((i) => Cast.fromJson(i));

    print(object['cast']);
    return Embedded(cast: listOfCast.toList());
  }
}

class Cast {
  Person person;

  Cast({this.person});

  factory Cast.fromJson(Map<String, dynamic> object) {
    return Cast(person: Person.fromJson(object['person']));
  }
}

class Person {
  String url, name;

  ImageCast image;

  Person({this.url, this.name, this.image});

  factory Person.fromJson(Map<String, dynamic> object) {
    print(object['image']);
    return Person(
      
        url: object['url'],
        name: object['name'],
        image: ImageCast?.fromJson(object['image'] ??= object['_links']));
  }
}

class ImageCast {
  String medium;

  ImageCast({this.medium});

  factory ImageCast.fromJson(Map<String, dynamic> object) {
    return ImageCast(medium: object['medium']);
  }
}

mixin required {}
