// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/pages/tabs/folders/addfolder.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/foldercard.dart';
import 'package:memestation/shared/slideup.dart';

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
              padding: EdgeInsets.all(20),
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
                  SlideUp(
                    title: 'Create new folder',
                    description: 'Please enter details below',
                    child: AddFolder(),
                    trigger: Icon(
                      Icons.add_circle,
                      color: Colors.black87,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            tabContent()
          ],
        ),
      ),
    );
  }

  Container tabContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(
        bottom: 20,
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
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _folders!.length,
                  itemBuilder: (context, index) {
                    return cardElement(_folders![index], () {});
                  },
                )
        ],
      ),
    );
  }
}
