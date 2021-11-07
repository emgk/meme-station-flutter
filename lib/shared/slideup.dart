// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';

class SlideUp extends StatelessWidget {
  String? title;
  String? description;
  Widget? trigger;
  Widget? child;
  bool? autoOpen = false;
  Function? onClose = () => {};

  SlideUp({
    Key? key,
    required this.title,
    this.trigger,
    this.description,
    this.child,
    this.onClose,
    this.autoOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (null != autoOpen) {
      return Container(
        child: slidePop(context),
      );
    }

    return InkWell(
      child: trigger,
      onTap: () {
        slidePop(context);
      },
    );
  }

  slidePop(context) {
    showModalBottomSheet(
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
                return slideContent(context);
              },
            ),
          );
        });
      },
    );
  }

  Container slideContent(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
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
                      title ?? 'Title',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      description ?? '',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      "NewParam0": "param0value",
                      "NewParam1": "param1value",
                      "NewParam2": "param2value"
                    });
                    onClose!();
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
              child: child ?? Container(),
            ),
          )
        ],
      ),
    );
  }
}
