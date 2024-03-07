import 'package:flutter/material.dart';

import '../resources/colours.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onTap;

  const RoundButton({
    super.key,
    required this.title,
    this.loading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: AppColours.buttonOKColour,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
            color: AppColours.whiteColour,
          )
              : Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColours.whiteColour,
            ),
          ),
        ),
      ),
    );
  }
}
