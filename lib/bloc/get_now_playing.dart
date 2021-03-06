import 'package:fluttermovie/model/movie_response.dart';
import 'package:fluttermovie/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingListBloc {
  final MovieRepo _repo = MovieRepo();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();
  getMovies() async {
    MovieResponse response = await _repo.getPlayingMovies();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final nowPlayingMoviesBloc = NowPlayingListBloc();
