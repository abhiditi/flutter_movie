import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/get_person_bloc.dart';
import 'package:fluttermovie/model/person.dart';
import 'package:fluttermovie/model/person_response.dart';
import 'package:fluttermovie/style/theme.dart' as Style;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonsList extends StatefulWidget {
  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  void initState() {
    super.initState();
    personsBloc..getPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "TRENDING PERSONS ON THIS WEEK",
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<PersonResponse>(
            stream: personsBloc.subject.stream,
            builder: (context, AsyncSnapshot<PersonResponse> snapShot) {
              if (snapShot.hasData) {
                if (snapShot.data.error != null &&
                    snapShot.data.error.length > 0) {
                  return _buildErrorWidget(snapShot.data.error);
                }
                return _buildPersonsWidget(snapShot.data);
              } else if (snapShot.hasError) {
                return _buildErrorWidget(snapShot.error);
              } else {
                return _buildLoadingWidget();
              }
            })
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("Error Occured:$error")],
      ),
    );
  }

  Widget _buildPersonsWidget(PersonResponse data) {
    List<Person> persons = data.person;
    return Container(
      height: 130.0,
      padding: EdgeInsets.only(left: 10.0),
      child: ListView.builder(
          itemCount: persons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 100.0,
              padding: EdgeInsets.only(top: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  persons[index].profileImg == null
                      ? Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Style.Colors.secondColor),
                          child: Icon(FontAwesomeIcons.userAlt,
                              color: Colors.white),
                        )
                      : Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200" +
                                          persons[index].profileImg),
                                  fit: BoxFit.cover)),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    persons[index].name,
                    maxLines: 2,
                    style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.0),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    "Trending for ${persons[index].known}",
                    style: TextStyle(
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.0),
                  )
                ],
              ),
            );
          }),
    );
  }
}
