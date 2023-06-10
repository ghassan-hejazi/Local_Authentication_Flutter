import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth_flutter/widget/elevated_button_widget.dart';
import 'package:local_auth_flutter/widget/showd_pattern_lock.dart';
import 'package:local_auth_flutter/widget/text_widget.dart';
import 'package:pattern_lock/pattern_lock.dart';

class CreatePatternLockPage extends StatefulWidget {
  const CreatePatternLockPage({super.key});

  @override
  State<CreatePatternLockPage> createState() => _CreatePatternLockPageState();
}

class _CreatePatternLockPageState extends State<CreatePatternLockPage> {
  final inputController = InputController();

  getStoragePatternLock(List<int> patternLock) {
    GetStorage().write('PatternLock', patternLock);
  }

  getStorageCreateLockPasscode(String lockPasscode) {
    GetStorage().write('LockPasscode', lockPasscode);
  }

  bool isConfirm = false;
  List<int>? pattern;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              onPressed: () {
                screenLockCreate(
                  context: context,
                  inputController: inputController,
                  onConfirmed: (value) {
                    setState(() {
                      getStorageCreateLockPasscode(value);
                    });
                  },
                );
              },
              text: 'Create Lock Passcode',
            ),
            const SizedBox(height: 16),
            const Divider(
              height: 20,
              color: Colors.black,
              thickness: 2,
            ),
            const SizedBox(height: 16),
            TextWidget(
              text: isConfirm ? "Confirm pattern" : "Draw pattern",
              fontSize: 26,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 16),
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
                  if (input.length < 3) {
                    showBottomSheetinWidget(
                      context,
                      TextWidget(
                        text: "At least 3 points required",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    );
                  }
                  if (isConfirm) {
                    if (listEquals<int>(input, pattern)) {
                      getStoragePatternLock(input);
                      Navigator.of(context).pop();
                    } else {
                      showBottomSheetinWidget(
                        context,
                        TextWidget(
                          text: "Patterns do not match",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      );

                      setState(() {
                        pattern = null;
                        isConfirm = false;
                      });
                    }
                  } else {
                    setState(() {
                      pattern = input;
                      isConfirm = true;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
