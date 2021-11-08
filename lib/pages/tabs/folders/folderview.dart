// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/loader.dart';
import 'package:memestation/shared/memecard.dart';

class FolderView extends StatefulWidget {
  final String folderId;
  final Function onBack;

  FolderView({
    Key? key,
    required this.folderId,
    required this.onBack,
  }) : super(key: key);

  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  Map<String, dynamic> params = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Text(widget.folderId ?? "no folder id passed");
    return SingleChildScrollView(
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          APIService.getFolderById(widget.folderId),
          APIService.getLoggedUser(),
          APIService.getMemes(widget.folderId),
          APIService.getFolders(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start');
            case ConnectionState.waiting:
              return screenLoader(context);
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.only(left: 30),
                            alignment: Alignment.center,
                            icon: Icon(Icons.arrow_back_ios, size: 15),
                            onPressed: () {
                              widget.onBack();
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![0]?.title ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          snapshot.data![0]?.description ?? "",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      snapshot.data![2].isNotEmpty
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data![2]!.length,
                              itemBuilder: (context, index) {
                                return MemeCard(
                                  meme: snapshot.data![2][index],
                                  user: snapshot.data![1],
                                  folders: snapshot.data![3],
                                );
                              },
                            )
                          : Column(
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 50),
                                          Icon(
                                            Icons.folder,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "No meme(s) found",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
