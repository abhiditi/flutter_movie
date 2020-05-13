import 'package:fluttermovie/model/person_response.dart';
import 'package:fluttermovie/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class PersonListBloc {
  final MovieRepo _repo = MovieRepo();
  final BehaviorSubject<PersonResponse> _subject =
      BehaviorSubject<PersonResponse>();
  getPerson() async {
    PersonResponse response = await _repo.getPerson();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<PersonResponse> get subject => _subject;
}

final personsBloc = PersonListBloc();
