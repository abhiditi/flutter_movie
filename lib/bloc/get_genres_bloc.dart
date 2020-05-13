import 'package:fluttermovie/model/genre_response.dart';
import 'package:fluttermovie/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class GenresListBloc {
  final MovieRepo _repo = MovieRepo();
  final BehaviorSubject<GenreResponse> _subject =
      BehaviorSubject<GenreResponse>();
  getGenres() async {
    GenreResponse response = await _repo.getGeners();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GenreResponse> get subject => _subject;
}

final genresBloc = GenresListBloc();
