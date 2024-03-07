import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/colours.dart';
import '../resources/text_styles.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {


  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColours.blackColour1,
      appBar: AppBar(
        backgroundColor: AppColours.greyColour,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: AppColours.highlightColour,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
            left: 16,
            top: 24,
            right: 16
        ),
        child: ListView(
          children:  <Widget>[
            SizedBox(height: height * .03),
            const Text(
              "Settings",
              style: PATextStyles.largeTextBold,
            ),
            SizedBox(height: height * .04),
            const Row(
              children: [
                Icon(
                  Icons.person_sharp,
                  color: AppColours.highlightColour,
                ),
                SizedBox( width: 8,),
                Text(
                  "Account",
                  style: PATextStyles.regularTextBold,
                ),
              ],
            ),
            SizedBox(height: height * .02),

            addDivider(),
            SizedBox(height: height * .02),
            buildRowSettingsItem("Change password", goToFakeRoute),
            SizedBox(height: height * .02),
            buildRowSettingsItem("Change email", goToFakeRoute),
            SizedBox(height: height * .02),
            buildRowSettingsItem("Change mobile number", goToFakeRoute),
            SizedBox(height: height * .04),
            const Row(
              children: [
                Icon(
                  Icons.tune_sharp,
                  color: AppColours.highlightColour,
                ),
                SizedBox( width: 8,),
                Text(
                  "Preferences",
                  style: PATextStyles.regularTextBold,
                ),
              ],
            ),
            SizedBox(height: height * .02),
            addDivider(),
            SizedBox(height: height * .02),
            buildSwitchRow("Notifications", fakeHandleSwitchChange),
            SizedBox(height: height * .02),
            buildSwitchRow("Kilometers(default) / Miles", fakeHandleSwitchChange),
            SizedBox(height: height * .04),
            Center(
              child: OutlinedButton(
                onPressed: (){},
                child: const Text(
                  "LOGOUT",
                  style: PATextStyles.largeText,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildSwitchRow(String optionsText, void Function(bool isActive) handleSwitchChange) {
    return Row(
      //  push the switch to the end of the row
      //  by setting the axis alignment
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          optionsText,
          style: PATextStyles.smallText,
        ),
        //  Scale down the switch widget
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            activeColor: AppColours.highlightColour,
            onChanged: handleSwitchChange,
            value: true,
          ),
        ),
      ],
    );
  }

  // dummy method for route to go to on pressed
  void goToFakeRoute(){}
  void fakeHandleSwitchChange(bool isActive){}

  Divider addDivider() {
    //height: 16, thickness: 2, color: AppColours.greyColour,
    return Divider(
      height: 16,
      thickness: 2,
      color: AppColours.greyColour.withOpacity(0.8),
    );
  }

  GestureDetector buildRowSettingsItem(
      String itemTitle,
      void Function() routeToGoMethod
      ) {
    return GestureDetector(
      onTap: routeToGoMethod,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemTitle,
            style: PATextStyles.smallText,
          ),
          const Icon(
            Icons.arrow_forward_sharp,
            color: AppColours.highlightColour,
          )
        ],
      ) ,
    );
  }
}