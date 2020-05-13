import 'package:flutter/cupertino.dart';
import 'package:fluttermovie/model/cast_response.dart';
import 'package:fluttermovie/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class CastsBloc {
  final MovieRepo _repo = MovieRepo();
  final BehaviorSubject<CastResponse> _subject =
      BehaviorSubject<CastResponse>();
  getCasts(int id) async {
    CastResponse response = await _repo.getCasts(id);
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

  BehaviorSubject<CastResponse> get subject => _subject;
}

final castsBloc = CastsBloc();
