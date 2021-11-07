// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:memestation/pages/tabs/folders/addfolder.dart';
import 'package:memestation/services/api_service.dart';
import 'package:memestation/shared/foldercard.dart';
import 'package:memestation/shared/formui.dart';
import 'package:memestation/shared/loader.dart';
import 'package:memestation/shared/slideup.dart';

void folderPicker(context, folders, onPick) async {
  await showModalBottomSheet(
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, state) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.9, //set this as you want
            maxChildSize: 1.0, //set this as you want
            minChildSize: 0.75, //set this as you want
            expand: true,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: header(
                  context,
                  folders,
                  onPick,
                ),
              );
            },
          ),
        );
      });
    },
  );
}

Column header(BuildContext context, folders, onPick) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Save to folder",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Please select folder below",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                // onClose!();
              },
              icon: Icon(
                Icons.close_sharp,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([APIService.getFolders()]),
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
                      child: !snapshot.data![0]!.isNotEmpty
                          ? noFolder()
                          : foldersList(
                              snapshot.data![0],
                              onPick,
                            ),
                      padding: EdgeInsets.all(20),
                    );
                  }
              }
            },
          ),
        ),
      )
    ],
  );
}

foldersList(folders, onPick) {
  return Column(children: [
    SlideUp(
      title: 'Create new folder',
      description: 'Please enter details below',
      onClose: () async {
        await APIService.getFolders();
      },
      child: FormInput(
        label: "",
        hasPadding: false,
        child: AddFolder(),
      ),
      trigger: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle,
                    color: Colors.black87,
                    size: 30,
                  ),
                  SizedBox(width: 5),
                  Text("Create new folder"),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    SizedBox(height: 5),
    ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: folders.length,
      itemBuilder: (context, index) {
        return cardElement(folders[index], (folder) {
          Navigator.of(context).pop();
          onPick(folder);
        });
      },
    )
  ]);
}

Column noFolder() {
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
