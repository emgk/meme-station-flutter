// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/pages/tabs/folders/addfolder.dart';
import 'package:memestation/services/api_service.dart';

class FoldersList extends StatefulWidget {
  FoldersList({
    Key? key,
  }) : super(key: key);

  @override
  _FoldersListState createState() => _FoldersListState();
}

class _FoldersListState extends State<FoldersList> {
  User? _user;
  List<Folder>? _folders;

  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();

    refreshKey = GlobalKey<RefreshIndicatorState>();

    loadFolders().whenComplete(() {
      setState(() {});
    });

    getCurrentUser().whenComplete(() {
      setState(() {});
    });
  }

  static GlobalKey _globalKey = GlobalKey();

  Future loadFolders() async {
    return await APIService.getFolders().then((folders) {
      _folders = folders;
    });
  }

  Future getCurrentUser() async {
    return await APIService.getLoggedUser().then((user) {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == _user) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black),
            strokeWidth: 5.0,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await loadFolders();
      },
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Folders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AddFolder(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 0),
              child: Column(
                children: [
                  !_user!.folders!.isNotEmpty
                      ? Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 50),
                                  Icon(
                                    Icons.folder,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "No folder",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Card(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _folders!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => {},
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      left: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        alignment: Alignment.center,
                                        height: 60,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          child: !_folders![index]
                                                  .memes!
                                                  .isNotEmpty
                                              ? Icon(
                                                  Icons.image,
                                                  color: Colors.black54,
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                  child: Image.network(
                                                    _folders![index]
                                                            .memes![0]
                                                            .imageUrl ??
                                                        '',
                                                    fit: BoxFit.fill,
                                                    width: 80,
                                                  ),
                                                ),
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _folders![index].title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            _folders![index].description,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
