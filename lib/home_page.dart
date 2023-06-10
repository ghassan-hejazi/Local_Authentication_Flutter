// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_flutter/create_pattern_lock_page.dart';
import 'package:local_auth_flutter/widget/elevated_button_widget.dart';
import 'package:local_auth_flutter/widget/showd_pattern_lock.dart';

import 'home2_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  localAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics =
        await auth.canCheckBiometrics; //القياسات الحيوية
    final bool canAuthenticate = canAuthenticateWithBiometrics ||
        await auth.isDeviceSupported(); //يدعم الجهاز والقياسات الحيوية
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (canAuthenticate == true) {
      if (availableBiometrics.isNotEmpty) {
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate',
              options: const AuthenticationOptions(
                stickyAuth: true,
                useErrorDialogs: true,
              ));
          auth.stopAuthentication();
          if (didAuthenticate == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          }
        } on PlatformException catch (e) {
          print(e.code);
        }
      }
    } else {
      print('object');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Local Authentication'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePatternLockPage(),
                  ));
            },
            icon: const Icon(Icons.enhanced_encryption),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              onPressed: () {
                localAuth();
              },
              text: 'LOGIN WITH BIOMETRICS',
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget(
              onPressed: () {
                showDialogPatternLock(context);
              },
              text: 'LOGIN Pattern Lock Dialog',
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget(
              onPressed: () {
                showBottomSheetPatternLock(context);
              },
              text: 'LOGIN Pattern Lock BottomSheet',
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget(
              onPressed: () {
                screenLock(
                  context: context,
                  correctString: GetStorage().read('LockPasscode'),
                  canCancel: true,
                  customizedButtonChild: const Icon(Icons.fingerprint),
                  customizedButtonTap: () async => await localAuth(),
                  onUnlocked: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                );
              },
              text: 'Lock Passcode',
            ),
          ],
        ),
      ),
    );
  }
}
