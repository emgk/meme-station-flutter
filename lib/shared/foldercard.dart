// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memestation/entities/jsonMap.dart';

GestureDetector cardElement(Folder folder, Function? onPick) {
  return GestureDetector(
    onTap: () {
      onPick!(folder);
    },
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
            margin: EdgeInsets.only(
              right: 20,
            ),
            alignment: Alignment.center,
            height: 60,
            child: Container(
              width: 60,
              height: 60,
              child: !folder.memes!.isNotEmpty
                  ? Icon(
                      Icons.image,
                      color: Colors.black54,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Image.network(
                        folder.memes![0].imageUrl ?? '',
                        fit: BoxFit.fill,
                        width: 80,
                      ),
                    ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
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
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 3),
              Text(
                folder.description,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
