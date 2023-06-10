import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth_flutter/home2_page.dart';
import 'package:local_auth_flutter/widget/text_widget.dart';
import 'package:pattern_lock/pattern_lock.dart';

showDialogPatternLock(context) {
  return AwesomeDialog(
    dialogType: DialogType.question,
    animType: AnimType.topSlide,
    padding: const EdgeInsets.all(8),
    context: context,
    title: 'question',
    body: Column(
      children: [
        TextWidget(
          text: 'Please enter the lock pattern',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: 300,
          child: PatternLock(
            selectedColor: Colors.red,
            pointRadius: 8,
            showInput: true,
            dimension: 3,
            relativePadding: 0.7,
            selectThreshold: 25,
            fillPoints: true,
            onInputComplete: (List<int> input) {
              if (listEquals<int>(input, GetStorage().read('PatternLock'))) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              } else {
                showBottomSheetinWidget(
                  context,
                  TextWidget(
                    text: "The pattern is incorrect",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      ],
    ),
  ).show();
}

showBottomSheetPatternLock(context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    enableDrag: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              color: Colors.indigoAccent,
              size: 70,
            ),
            const SizedBox(height: 32),
            TextWidget(
              text: 'Please enter the lock pattern',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 300,
              child: PatternLock(
                selectedColor: Colors.red,
                pointRadius: 8,
                showInput: true,
                dimension: 3,
                relativePadding: 0.7,
                selectThreshold: 25,
                fillPoints: true,
                onInputComplete: (input) {
                  if (listEquals<int>(
                      input, GetStorage().read('PatternLock'))) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  } else {
                    showBottomSheetinWidget(
                      context,
                      TextWidget(
                        text: "The pattern is incorrect",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

showBottomSheetinWidget(context, Widget content) {
  return showModalBottomSheet<void>(
    backgroundColor: Colors.black,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 50,
        child: Center(child: content),
      );
    },
  );
}
