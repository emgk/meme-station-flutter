// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  String? label;
  Widget? child;
  bool? hasPadding;

  FormInput({
    Key? key,
    required this.label,
    this.child,
    this.hasPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: null == hasPadding
          ? EdgeInsets.only(left: 20, right: 20)
          : EdgeInsets.all(0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  right: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  left: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: child,
            ),
          ]),
    );
  }
}

class FormButton extends StatelessWidget {
  String? label;
  Function? onClick;
  bool? isDisabled;

  FormButton({
    Key? key,
    required this.label,
    this.onClick,
    this.isDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("isDisabled $isDisabled");
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: InkWell(
            onTap: () => onClick!(),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                label ?? 'Submit',
                style: TextStyle(
                  fontSize: 18,
                  color: true != isDisabled ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.w700,
                ),
              ),
              decoration: BoxDecoration(
                color:
                    true != isDisabled ? Colors.orangeAccent : Colors.grey[300],
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color:
                        true != isDisabled ? Colors.orangeAccent : Colors.white,
                    offset: Offset(6, 2),
                    blurRadius: 2.0,
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
