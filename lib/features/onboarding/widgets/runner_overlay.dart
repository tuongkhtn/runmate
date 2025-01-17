import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:runmate/common/providers/user_id_provider.dart";
import "../../../common/utils/constants.dart";

class RunnerOverlay extends StatelessWidget {
  const RunnerOverlay({super.key});

  void handleGetStarted(BuildContext context) {
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    final user = userProvider.userId;

    if(user != null) {
      Navigator.pushNamed(context, "/let_run");
    } else {
      Navigator.pushNamed(context, "/let_run");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Connect with a Community of Runners",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Join a global network of runners and share your achievements. Challenge friends, participate in virtual races, and celebrate your progress together.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              )
            ),

            const SizedBox(height: 15,),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/login"),
              child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                      'Get Started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      )
                  )
              ),

            ),

            const SizedBox(height: 15),

            Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          )
                      )
                    )
                  )
                ]
              )
            )
          ],
        )
      )
    );
  }
}