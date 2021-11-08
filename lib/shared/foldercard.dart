// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memestation/entities/jsonMap.dart';

GestureDetector cardElement(Folder folder, [Function? onPick]) {
  return GestureDetector(
    onTap: () {
      if (null != onPick) {
        onPick(folder);
      }
    },
    child: Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(2),
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
            margin: EdgeInsets.only(
              right: 10,
            ),
            alignment: Alignment.center,
            height: 40,
            child: Container(
              width: 40,
              height: 40,
              child: !folder.memes!.isNotEmpty
                  ? Icon(
                      Icons.folder,
                      color: Colors.grey,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        bottomLeft: Radius.circular(2),
                      ),
                      child: Image.network(
                        folder.memes![0].imageUrl ?? '',
                        fit: BoxFit.fill,
                        width: 80,
                      ),
                    ),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                folder.title,
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 3),
              // Text(
              //   folder.description,
              //   overflow: TextOverflow.ellipsis,
              //   style: TextStyle(),
              // ),
            ],
          )
        ],
      ),
    ),
  );
}
