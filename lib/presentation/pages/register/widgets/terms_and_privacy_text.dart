import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndPrivacyText extends StatelessWidget {
  
  final Uri termsUrl = Uri.parse(AppTexts.urlTermsOfService);
  final Uri privacyUrl = Uri.parse(AppTexts.urlPrivacyPolicy);

 TermsAndPrivacyText({super.key});


  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14),
        children: <TextSpan>[
          const TextSpan(text: AppTexts.termsTextFirstPart),
          TextSpan(
            text: AppTexts.termsOfService,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(termsUrl);
              },
          ),
          const TextSpan(text: AppTexts.termsTextSecondPart),
          TextSpan(
            text: AppTexts.privacyPolicy,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchUrl(privacyUrl);
              },
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
