import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../resources/styles_constants.dart';
import '../resources/text_string.dart';
import '../utilities/utils.dart';
import '../view_models/verify_email_vm.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key, required this.emailAddress});

  final String emailAddress;

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {

  @override
  Widget build(BuildContext context) {

    final dark = Utils.isDarkMode(context);
    final verifyEmailVM = Provider.of<VerifyEmailViewModel>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        // Remove the leading back arrow
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, AppConsts.rootLogin);
            },
            icon: const Icon(Icons.close_sharp),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PAAppStylesConstants.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(image: const AssetImage( AppConsts.verifyEmailImage), width: Utils.getScreenWidth(context) * 0.8),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),

              // Title & Subtitle
              Text(PATextString.verifyEmailAddress, style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
              Text(widget.emailAddress, style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
              Text(PATextString.congratulationsPleaseVerify, style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenSections,),

              // Buttons
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: (){
                  verifyEmailVM.continueClick(context);
                },
                child: const Text(PATextString.pleaseContinue),
              ),
              ),
              const SizedBox(height: PAAppStylesConstants.spaceBetweenItems,),
              SizedBox(width: double.infinity, child: TextButton(
                onPressed: (){
                  //verifyEmailVM.setEmailAddress(widget.emailAddress);
                  verifyEmailVM.resendVerificationToken(context);
                },
                child: const Text(PATextString.resendEmail),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
