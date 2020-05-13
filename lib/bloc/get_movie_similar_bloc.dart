import 'package:flutter/cupertino.dart';
import 'package:fluttermovie/model/movie_response.dart';
import 'package:fluttermovie/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class SimilarMoviesBloc {
  final MovieRepo _repo = MovieRepo();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();
  getSimilarMovies(int id) async {
    MovieResponse response = await _repo.getSimilarMovies(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final similarMoviesBloc = SimilarMoviesBloc();
