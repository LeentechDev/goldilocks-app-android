import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/elements/BlockButtonWidget.dart';


class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).accentColor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Container(
                  //  alignment: Alignment.centerRight,
                  //  child: FlatButton(
                  //    onPressed: () => print('Skip'),
                  //    child: Text(
                  //      'Skip',
                  //      style: TextStyle(
                  //        color: Colors.white,
                  //        fontSize: 20.0,
                  //      ),
                  //    ),
                  //  ),
                  //),

                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: 600.0,
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/custom_img/onboarding1.png',
                                    ),
                                    height: MediaQuery.of(context).size.height / 2.2,
                                    width: MediaQuery.of(context).size.width / 1,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                AutoSizeText(
                                  'Choose from more than 50 Goldilocks stores.',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(height: 15.0),
                                AutoSizeText(
                                  'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.',
                                  style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).dividerColor)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/custom_img/onboarding2.png',
                                    ),
                                    height: MediaQuery.of(context).size.height / 2.2,
                                    width: MediaQuery.of(context).size.width / 1,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                AutoSizeText(
                                  'Hassle-free order option',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(height: 15.0),
                                AutoSizeText(
                                  'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.',
                                  style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).dividerColor)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/custom_img/onboarding3.png',
                                    ),
                                    height: MediaQuery.of(context).size.height / 2.2,
                                    width: MediaQuery.of(context).size.width / 1,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                AutoSizeText(
                                  'Cashless transactions',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(height: 15.0),
                                AutoSizeText(
                                  'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.',
                                  style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).dividerColor)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
        height: MediaQuery.of(context).size.height / 9,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: BlockButtonWidget(
          color: Theme.of(context).accentColor,
          text: AutoSizeText('Get Started',style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),),
          onPressed: (){
            Navigator.of(context).pushReplacementNamed('/Login',);
          },
        ),
      )
          : SizedBox(),
    );
  }
}

