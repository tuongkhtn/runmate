import "package:flutter/material.dart";
import "../utils/constants.dart";

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor = kPrimaryColor,
    this.textColor = kSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
        ? const CircularProgressIndicator(
        color: Colors.white,
      ) : Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
      )
    );
  }
}