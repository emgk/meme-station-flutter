// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, unused_label

import 'package:flutter/material.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/pages/tabs/folders/addfolder.dart';
import 'package:memestation/pages/tabs/folders/folderview.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/foldercard.dart';
import 'package:memestation/shared/loader.dart';
import 'package:memestation/shared/slideup.dart';

class FoldersList extends StatefulWidget {
  FoldersList({
    Key? key,
  }) : super(key: key);

  @override
  _FoldersListState createState() => _FoldersListState();
}

class _FoldersListState extends State<FoldersList> {
  List<Folder>? folders;
  String? folderId;

  late GlobalKey<RefreshIndicatorState> refreshKey;

  Future getFolders() async {
    return await APIService.getFolders().then((folders) {
      setState(() {
        folders = folders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null != folderId) {
      return FolderView(
        folderId: folderId ?? '',
        onBack: () {
          setState(() {
            folderId = null;
          });
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await APIService.getFolders();
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "folders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          await APIService.getFolders();
                          setState(() {});
                        },
                      ),
                      SlideUp(
                        title: 'Create new folder',
                        description: 'Please enter details below',
                        child: AddFolder(),
                        trigger: Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: APIService.getFolders(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start');
                  case ConnectionState.waiting:
                    return screenLoader(context);
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 0,
                            ),
                            padding:
                                EdgeInsets.only(left: 15, right: 15, top: 0),
                            child: tabContent(snapshot.data, setState),
                          ),
                        ],
                      );
                    }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  tabContent(data, setState) {
    onPick(Folder folder) {
      folderId = folder.id;
      setState(() {
        folderId:
        folder.id;
      });
    }

    if (!data!.isNotEmpty) {
      return Column(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          )
        ],
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data!.length,
      itemBuilder: (context, index) {
        return cardElement(data![index], onPick);
      },
    );
  }
}
