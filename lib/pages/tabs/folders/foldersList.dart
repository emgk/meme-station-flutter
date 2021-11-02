// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:memestation/entities/jsonMap.dart';
import 'package:memestation/pages/login.dart';
import 'package:memestation/pages/memeslist.dart';
import 'package:memestation/services/api_service.dart';

class FoldersList extends StatefulWidget {
  // final String user;
  // const FoldersList({Key? key, required this.user}) : super(key: key);

  @override
  _FoldersListState createState() => _FoldersListState();
}

class _FoldersListState extends State<FoldersList> {
  User? _user;

  @override
  void initState() {
    super.initState();

    getCurrentUser().whenComplete(() {
      setState(() {});
    });
  }

  Future getCurrentUser() async {
    return await APIService.getLoggedUser().then((user) {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("fdsfsdfsdf");
  }
}
