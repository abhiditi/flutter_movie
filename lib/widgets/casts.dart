import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/get_casts_bloc.dart';
import 'package:fluttermovie/model/cast.dart';
import 'package:fluttermovie/model/cast_response.dart';
import 'package:fluttermovie/style/theme.dart' as Style;

class Casts extends StatefulWidget {
  final int id;
  Casts({Key key, @required this.id}) : super(key: key);
  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);
  @override
  void initState() {
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "CASES",
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<CastResponse>(
            stream: castsBloc.subject.stream,
            builder: (context, AsyncSnapshot<CastResponse> snapShot) {
              if (snapShot.hasData) {
                if (snapShot.data.error != null &&
                    snapShot.data.error.length > 0) {
                  return _buildErrorWidget(snapShot.data.error);
                }
                return _buildCastsWidget(snapShot.data);
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

  Widget _buildCastsWidget(CastResponse data) {
    List<Cast> casts = data.casts;
    return Container(
      height: 140.0,
      padding: EdgeInsets.only(left: 10.0),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: casts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10.0),
              // width: 100.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            // fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w300/" +
                                    casts[index].img),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    casts[index].name,
                    maxLines: 2,
                    style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text(
                        casts[index].character,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Style.Colors.titleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 7.0),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
