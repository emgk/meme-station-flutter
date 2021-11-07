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
        await getFolders();
      },
      child: Column(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: FutureBuilder<List<dynamic>>(
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
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 20, right: 20),
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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 0,
                            ),
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            child: tabContent(snapshot.data, setState),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          )
        ],
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
