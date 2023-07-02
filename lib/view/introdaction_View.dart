import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import 'package:yukopiapps/modules/chek_login.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      imagePadding: EdgeInsets.all(10),
    );

    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        pages: [
          PageViewModel(
            title: "Pesan Kopi Mu",
            body:
                "Mudah Pesan Kopi hanya lewat Hp mu , kamu juga bisa tau lebih jauh tentang kopi yang kamu pesan",
            image: Center(
              child: Lottie.asset(
                "assets/intro2.json",
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Nikmati Kopi Terbaik",
            body:
                "Di siapkan dengan baham berkualitas tinggi sehingga menghadirkan citra rasa yang sempurna",
            image: Center(
              child: Image.asset(
                "assets/intro2.png",
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Pelayanan Ahli",
            body:
                "Disiapkan oleh barisata profesiona, yang membuat citra rasa kopi lebih sempurna",
            image: Center(
              child: Image.asset(
                "assets/intro3.png",
              ),
            ),
            decoration: pageDecoration.copyWith(
              bodyFlex: 6,
              imageFlex: 6,
              safeArea: 10,
            ),
          ),
        ],
        onDone: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CheckLoginPage(),
            ),
          );
        },
        showSkipButton: true,
        showNextButton: true,
        showDoneButton: true,
        showBackButton: false,
        dotsFlex: 3,
        nextFlex: 1,
        skipOrBackFlex: 1,
        back: const Icon(Icons.arrow_back),
        skip: const Text(
          "Skip",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        next: const Icon(Icons.arrow_forward),
        done: const Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        dotsDecorator: const DotsDecorator(
          size: Size(10, 10),
          color: Colors.grey,
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }
}
