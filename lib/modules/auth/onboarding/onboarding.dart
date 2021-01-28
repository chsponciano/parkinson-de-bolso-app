import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_up/sign_up.dart';
import 'package:parkinson_de_bolso/widget/custom_footer_button.dart';
import 'package:parkinson_de_bolso/widget/custom_footer_group_button.dart';
import 'package:parkinson_de_bolso/widget/custom_scaffold.dart';
import 'informative_illustration.dart';

class Onboarding extends StatefulWidget {
  static const String routeName = '/';

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: defaultGradient),
        child: Column(
          children: <Widget>[
            InformativeIllustration(),
            CustomFooterGroupButton(
              buttons: [
                CustomFooterButton(
                  background: ternaryColor,
                  label: titleSignIn,
                  onPressed: () => Navigator.pushNamed(context, SignIn.routeName),
                ),
                CustomFooterButton(
                  background: ternaryColor,
                  label: titleSignUp,
                  onPressed: () => Navigator.pushNamed(context, SignUp.routeName),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
