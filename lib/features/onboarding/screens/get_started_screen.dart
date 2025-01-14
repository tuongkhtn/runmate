import "package:flutter/material.dart";
import "../widgets/runner_overlay.dart";

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const Positioned(
              left: 20,
              right: 20,
              bottom: 30,
              child: RunnerOverlay(),
            ),
          ],
        )
    );
  }
}