import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_guard/theme.dart';

void main() {
  runApp(HouseGuardApp());
}

class HouseGuardApp extends StatelessWidget {
  const HouseGuardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  double get w => MediaQuery.of(context).size.width;

  double get h => MediaQuery.of(context).size.height;

  bool isOpened = false;
  bool menuOpen = true;
  bool textCtrl = false;

  String _animation = "open";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            //sekcja z listą
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 240),
                      width: w,
                      height: menuOpen ? 350 : 270,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 240),
                      height: menuOpen ? 180 : 130,
                    ),
                    ...tiles.map((e) {
                      return CustomListTile(
                          w: w,
                          img: e.img,
                          title: e.title,
                          subtitle: e.subtitle,
                          isOpened: isOpened,
                          onTap: () {
                            setState(() {
                              isOpened = !isOpened;
                            });
                          },
                          key: ValueKey(e.hashCode));
                    }).toList(),
                    SizedBox(height: 36),
                    Container(
                      width: 54,
                      height: 54,
                      child: Center(
                        child: Icon(Icons.add, color: MyTheme.grey),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: MyTheme.lightGrey,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Add New Device",
                      style: TextStyle(
                        color: MyTheme.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 36),
                  ],
                ),
              ),
            ),
            //sekcja z animacją
            AnimatedContainer(
              duration: Duration(milliseconds: 240),
              width: w,
              height: menuOpen ? 400 : 420,
              color: MyTheme.indigo,
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 240),
                    left: menuOpen ? 220 : (w - 300) / 2,
                    top: menuOpen ? -160 : -165,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 240),
                      width: menuOpen ? 900 : 300,
                      height: menuOpen ? 900 : 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyTheme.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AnimatedPositioned(
              duration: Duration(milliseconds: 360),
              top: menuOpen ? -100 : 66,
              left: 156,
              child: Container(
                width: 32,
                height: 32,
                child: Image.asset(
                  "assets/images/cloud.png",
                  color: Colors.white,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 360),
              top: menuOpen ? -100 : 66,
              left: 230,
              child: Container(
                width: 64,
                height: 64,
                child: Image.asset(
                  "assets/images/cloud.png",
                  color: Colors.white,
                ),
              ),
            ),
            //! Bolts
            ...bolts.map((e) {
              return BoltWidget(
                menuOpen: menuOpen,
                w: w,
                boltModel: e,
                key: ValueKey(e.hashCode),
              );
            }).toList(),
            //! Flare
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: w,
                height: 380,
                child: FlareActor(
                  "assets/images/hero.flr",
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                  animation: _animation,
                ),
              ),
            ),
            //sekcja z nazwą aplikacji
            AnimatedPositioned(
              duration: Duration(milliseconds: 360),
              top: menuOpen ? 248 : 164,
              left: 0,
              child: Container(
                width: w,
                child: AnimatedPadding(
                  duration: Duration(milliseconds: 360),
                  padding: EdgeInsets.symmetric(horizontal: textCtrl ? 12 : 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AnimatedDefaultTextStyle(
                            child: Text(
                              "building",
                            ),
                            style: TextStyle(
                              fontSize: textCtrl ? 36 : 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            duration: Duration(milliseconds: 360),
                          ),
                          AnimatedDefaultTextStyle(
                            child: Text(
                              "GuardApp",
                            ),
                            style: TextStyle(
                              fontSize: textCtrl ? 54 : 36,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            duration: Duration(milliseconds: 360),
                          ),
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: <Widget>[
                      //     AnimatedDefaultTextStyle(
                      //       child: Text(
                      //         "1 objects",
                      //       ),
                      //       style: TextStyle(
                      //         fontSize: textCtrl ? 34 : 22,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      //       duration: Duration(milliseconds: 360),
                      //     ),
                      //     AnimatedDefaultTextStyle(
                      //       child: Text(
                      //         "Alarm engaged",
                      //       ),
                      //       style: TextStyle(
                      //         fontSize: textCtrl ? 36 : 22,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      //       duration: Duration(milliseconds: 360),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            //! Gateway
            //sekcja z białym panel i pipsztokiem od alarmu
            AnimatedPositioned(
              duration: Duration(milliseconds: 360),
              top: menuOpen ? 335 : 255,
              left: 24,
              child: Container(
                width: w - 48,
                height: 160,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: (w - 48) / 2,
                      height: 110,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/alarm.png"),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(24),
                        ),
                      ),
                    ),
                    Container(
                      width: (w - 48) / 2,
                      height: 160,
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          SizedBox(height: 24),
                          Text(
                            "Alarm",
                            style: TextStyle(
                              color: MyTheme.textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Online",
                            style: TextStyle(
                              color: MyTheme.grey,
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          CustomSwitch(
                            isOpened: menuOpen,
                            onTap: () {
                              if (menuOpen) {
                                setState(() {
                                  _animation = "close";
                                });
                              } else {
                                setState(() {
                                  _animation = "open";
                                });
                              }

                              setState(() {
                                textCtrl = true;
                                menuOpen = !menuOpen;
                              });

                              Future.delayed(Duration(milliseconds: 160), () {
                                setState(() {
                                  textCtrl = false;
                                });
                              });
                              print("object");
                            },
                            key: ValueKey('123'),
                          ),
                          SizedBox(height: 24),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: MyTheme.indigo.withOpacity(0.3),
                      offset: Offset(8, 8),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            //sekcja z menu
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Container(
                  width: w,
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/menu_lines.png",
                        color: Colors.white,
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BoltModel {
  final double topBefore;
  final double leftBefore;
  final double size;
  final String img;

  BoltModel(this.topBefore, this.leftBefore, this.size, this.img);
}

List<BoltModel> bolts = [
  BoltModel(90, 104, 50, "assets/images/flash_left.png"),
  BoltModel(180, 32, 68, "assets/images/flash_left.png"),
  BoltModel(84, 284, 60, "assets/images/flash_right.png"),
  BoltModel(200, 352, 64, "assets/images/flash_right.png"),
];

class BoltWidget extends StatelessWidget {
  final bool menuOpen;
  final double w;
  final BoltModel boltModel;

  const BoltWidget(
      {required Key key,
      required this.menuOpen,
      required this.w,
      required this.boltModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 360),
      curve: Curves.easeIn,
      top: menuOpen ? boltModel.topBefore : 460,
      left: menuOpen ? boltModel.leftBefore : (w - boltModel.size) / 2,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 360),
        width: menuOpen ? boltModel.size : 5,
        height: menuOpen ? boltModel.size : 5,
        padding: EdgeInsets.all(5),
        child: Image.asset(
          boltModel.img,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomTileModel {
  final String title;
  final String subtitle;
  final String img;

  CustomTileModel(this.title, this.subtitle, this.img);
}

List<CustomTileModel> tiles = [
  CustomTileModel("My Lamp", "Online", "assets/images/my_lamp.png"),
  CustomTileModel("Philips Lamp", "Online", "assets/images/phlilips_lamp.png"),
  CustomTileModel("Camera", "Sleeping", "assets/images/camera.png"),
  CustomTileModel("mi Fan", "Online", "assets/images/mi_fan.png"),
];

class CustomListTile extends StatelessWidget {
  final double w;
  final String img;
  final String title;
  final String subtitle;
  final bool isOpened;
  final VoidCallback onTap;

  const CustomListTile(
      {required Key key,
      required this.w,
      required this.img,
      required this.title,
      required this.subtitle,
      required this.isOpened,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w - 48,
      height: 102,
      padding: EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 2,
            color: MyTheme.lightGrey,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: MyTheme.textColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: MyTheme.textColor,
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: MyTheme.grey,
                ),
              )
            ],
          ),
          Spacer(),
          CustomSwitch(
            isOpened: isOpened,
            onTap: onTap,
            key: const Key("any_key3"),
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool isOpened;
  final VoidCallback onTap;

  const CustomSwitch(
      {required Key key, required this.isOpened, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 240),
        width: 74,
        height: 44,
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 240),
              top: 2,
              left: isOpened ? 32 : 2,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(44),
          color: isOpened ? MyTheme.pink : MyTheme.lightGrey,
        ),
      ),
    );
  }
}
