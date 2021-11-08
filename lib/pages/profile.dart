// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/services/api_provider.dart';
import 'package:memestation/services/api_service.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> params = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: ApiProvider().getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/profile-cover.jpg'), //your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          Gravatar(
                                            snapshot.data!.email ?? '',
                                          ).imageUrl(),
                                          height: 60.0,
                                          width: 60.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    Text(
                                      snapshot.data!.name ?? '',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Text(
                                    //   (Jiffy(snapshot.data!.createdAt)
                                    //       .fromNow()),
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    children: [
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                      Text("PROFILE"),
                    ],
                  ),
                ),
              )
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
