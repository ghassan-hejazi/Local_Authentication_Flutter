// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:local_auth_flutter/widget/text_widget.dart';

class ElevatedButtonWidget extends StatelessWidget {
  ElevatedButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);
  Function() onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        backgroundColor: Colors.blueAccent,
        minimumSize: const Size(double.infinity, 60),
      ),
      child: TextWidget(
        text: text,
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
