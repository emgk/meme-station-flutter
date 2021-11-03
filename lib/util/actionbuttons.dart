// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void folderPicker(context, folders, onPick) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isDismissible: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75, //set this as you want
        maxChildSize: 0.75, //set this as you want
        minChildSize: 0.75, //set this as you want
        expand: true,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Save to folder",
                            style: TextStyle(
                              fontSize: 25,
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
                          SizedBox(height: 15),
                        ],
                      ),
                      IconButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        icon: Icon(
                          Icons.close_sharp,
                        ),
                      ),
                    ],
                  ),
                  !folders.isNotEmpty
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
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                onPick(folders[index]);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      alignment: Alignment.center,
                                      height: 60,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child:
                                            !folders![index].memes!.isNotEmpty
                                                ? Icon(
                                                    Icons.image,
                                                    color: Colors.black54,
                                                  )
                                                : Image.network(
                                                    folders![index]
                                                        .memes![0]
                                                        .imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 60,
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
                                          folders![index].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          folders![index].description,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
