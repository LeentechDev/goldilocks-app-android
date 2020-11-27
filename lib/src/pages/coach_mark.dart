import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_svg/svg.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CoachMark extends StatefulWidget {

    static final GlobalKey<_CoachMarkState> staticGlobalKey =
      new GlobalKey<_CoachMarkState>();

    static final GlobalKey keyButton1 = new GlobalKey();
    static final GlobalKey keyButton = new GlobalKey();
    static final GlobalKey keyButton2 =new GlobalKey();

  @override
  _CoachMarkState createState() => _CoachMarkState();
}



class _CoachMarkState extends State<CoachMark> {

    TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();



  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Theme.of(context).hintColor,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      print("finish");
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }



  void initTargets() {
    
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 0",
        keyTarget: CoachMark.keyButton,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        "Here's where you can \nchange your location",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ],
                ),
              ),),
              ContentTarget(
                align: AlignContent.bottom,
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 400),
                            child: SvgPicture.asset('assets/custom_img/tap_icon.svg')
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child:AutoSizeText('Tap to Continue',
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ],
                      ),
              ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 1",
        keyTarget: CoachMark.keyButton1,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        "Here's your cart where you \ncan see all of the items \nyou want to order.",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white),

                      ),
                    )
                  ],
                ),
              ),),
              ContentTarget(
                align: AlignContent.bottom,
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 400),
                            child: SvgPicture.asset('assets/custom_img/tap_icon.svg')
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child:AutoSizeText('Tap to Continue',
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ],
                      ),
              ),
        ],
        shape: ShapeLightFocus.Circle,
        
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 2",
        keyTarget: CoachMark.keyButton2,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        "Tap this to change the \norder type",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white),

                      ),
                    )
                  ],
                ),
              ),),
              ContentTarget(
                align: AlignContent.bottom,
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 190),
                            child: SvgPicture.asset('assets/custom_img/tap_icon.svg')
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 400),
                            child:AutoSizeText('Tap to Continue',
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ],
                      ),
              ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
  }
  //coachmark ^
  
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  
  //CoachMark 
  }
}