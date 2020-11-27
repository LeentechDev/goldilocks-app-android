import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../elements/BlockButtonWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Walkthrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new WalkthroughWidget(),
    );
  }
}

class WalkthroughWidget extends StatefulWidget {
  WalkthroughWidget({
    Key key,
  }) : super(key: key);

  @override
  _WalkthroughWidgetState createState() => _WalkthroughWidgetState();
}

class _WalkthroughWidgetState extends StateMVC<WalkthroughWidget> {

  SwiperController _controller;
  int currentIndex = 0;

  List<Map<String, dynamic>> listItem = [
    {
      "id": '0',
      "title": 'Choose from more than 50 Goldilocks stores.',
      "description": "Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.",
      "image": "assets/custom_img/cart.png"
    },
    {
      "id": '1',
      "title": 'Hassle-free order option',
      "description": "Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.",
      "image": "assets/custom_img/store.png"
    },
    {
      "id": '2',
      "title": 'Cashless payment options',
      "description": "Far far away, behind the word mountains, far from the countries Vokalia and Consonantia.",
      "image": "assets/custom_img/delivery.png"
    },
  ];



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              height: screenSize.height * 0.58,
              width: double.infinity,
              padding: EdgeInsets.only(top: 20.0),
              child: Swiper(
                curve: Curves.easeInOut,
                controller: _controller,
                itemCount: 3,
                itemHeight: 200.0,
                viewportFraction: 0.6,
                scale: 0.6,
                loop: false,
                outer: true,
                index: currentIndex,
                onIndexChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                listItem[index]['image'],
                              ),
                              fit: BoxFit.contain),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  );
                },
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    size: 5.0,
                    activeSize: 10.0,
                    space: 5.0,
                    color: Colors.grey,
                    activeColor: Color(0xFFFECD00),
                  ),
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(
                top: screenSize.height * 0.09,
                left: screenSize.width * 0.1,
                right: screenSize.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  "${listItem[currentIndex]['title']}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.only(top: 6),
                  child: AutoSizeText(
                    "${listItem[currentIndex]['description']}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14, color: Colors.black,),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: currentIndex == 2
                ? Container(
              padding: EdgeInsets.only(
                bottom: screenSize.height * 0.06,
                left: screenSize.width * 0.1,
                right: screenSize.width * 0.1,
              ),
              child: BlockButtonWidget(
                text: AutoSizeText(
                  "Continue",
                  style: TextStyle(color: Colors.black),
                ),
                color: Color(0xFFFECD00),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/Login');
                },
              ),
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
