import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final smartAuth = SmartAuth();
  final pinputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAppSignature();
    getSmsCode();
  }

  @override
  void dispose() {
    smartAuth.removeSmsListener();
    pinputController.dispose();
    super.dispose();
  }

  void getAppSignature() async {
    final res = await smartAuth.getAppSignature();
    debugPrint('Signature: $res');
  }

  void requestHint() async {
    final res = await smartAuth.requestHint(
      isPhoneNumberIdentifierSupported: true,
      isEmailAddressIdentifierSupported: true,
      showCancelButton: true,
    );
    debugPrint('requestHint: $res');
  }

  void getSmsCode() async {
    final res = await smartAuth.getSmsCode();
    if (res.succeed) {
      pinputController.setText(res.code!);
      debugPrint('SMS: ${res.code}');
    } else {
      debugPrint('SMS Failure: ${res.sms}');
    }
  }

  void removeSmsListener() {
    smartAuth.removeSmsListener();
  }

  // identifier Url
  final accountType = 'https://developers.google.com';

  // Value you want to save, phone number or email for example
  final credentialId = 'Credential Id';
  final credentialName = 'Credential Name';
  final profilePictureUri = 'https://profilePictureUri.com';

  void saveCredential() async {
    final res = await smartAuth.saveCredential(
      id: credentialId,
      name: credentialName,
      accountType: accountType,
      profilePictureUri: profilePictureUri,
    );
    debugPrint('saveCredentials: $res');
  }

  void getCredential() async {
    final res = await smartAuth.getCredential(
      accountType: accountType,
      showResolveDialog: true,
    );
    debugPrint('getCredentials: $res');
  }

  void deleteCredential() async {
    final res = await smartAuth.deleteCredential(
      id: credentialId,
      accountType: accountType,
    );
    debugPrint('removeCredentials: $res');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(controller: pinputController),
            TextButton(
              onPressed: requestHint,
              child: const Text('Request Hint'),
            ),
            TextButton(
              onPressed: getCredential,
              child: const Text('Get Credential'),
            ),
            TextButton(
              onPressed: saveCredential,
              child: const Text('Save Credential'),
            ),
            TextButton(
              onPressed: deleteCredential,
              child: const Text('Delete Credential'),
            ),
          ],
        ),
      ),
    );
  }
}
