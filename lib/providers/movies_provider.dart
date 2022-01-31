import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculasapp/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = '037919d72bcd63516b8a4871793df7d3';
  final String _baseUrl = 'api.themoviedb.org';
  final String _languaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  MoviesProvider(){

    getOnDisplayMovies();
    getPopularMovie();
  }

  Future <String> _getJsonData(String endpoint, [int page = 1]) async{
    var url = Uri.https(_baseUrl, endpoint,{
      'api_key':_apiKey,
      'languaje':_languaje,
      'page': '$page'
    });

    var response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async{
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlyeingresponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlyeingresponse.results;
    notifyListeners();
  }


  getPopularMovie() async{
    _popularPage ++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }


  Future<List<Cast>> getMovieCast(int movieId) async{
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }
}