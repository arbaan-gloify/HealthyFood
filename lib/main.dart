import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:notifications/cart/detail_page.dart';
import 'package:notifications/splash_screen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', //id
  'High Importance Notification', //title
  importance: Importance.high,
  playSound: true,
  description: 'This Channel is used for important notification.', //description
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseeBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("A Bg messege ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseeBackgroundMessage);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MySplashScreen(),
        '/home': (context) => const MyHomePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.high,
                priority: Priority.high,
                playSound: true,
              ),
            ),
          );
        }
      },
    );
    // Firebase Messaging notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(notification.title!),
            );
          },
        );
      }
    });
  }

  void incrementCount() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Row(
                      children: const [
                        Text('Healthy',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0)),
                        SizedBox(width: 10.0),
                        Text('Food',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.green,
                                fontSize: 25.0))
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(75.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 35.0,
                        left: 20,
                      ),
                      child: SizedBox(
                        child: ListView(
                          children: [
                            _buildFoodItem(
                              context: context,
                              imgPath: 'assets/plate1.png',
                              foodName: 'Salmon bowl',
                              price: '\$24.00',
                            ),
                            _buildFoodItem(
                              context: context,
                              imgPath: 'assets/plate2.png',
                              foodName: 'Spring bowl',
                              price: '\$22.00',
                            ),
                            _buildFoodItem(
                              context: context,
                              imgPath: 'assets/plate6.png',
                              foodName: 'Avocado bowl',
                              price: '\$26.00',
                            ),
                            _buildFoodItem(
                              context: context,
                              imgPath: 'assets/plate5.png',
                              foodName: 'Berry bowl',
                              price: '\$24.00',
                            ),
                            _buildFoodItem(
                              context: context,
                              imgPath: 'assets/plate3.png',
                              foodName: 'Meat bowl',
                              price: '\$40.00',
                            ),
                            _buildFoodItem(
                              context: context,
                              imgPath: 'assets/plate4.png',
                              foodName: 'Brockly bowl',
                              price: '\$29.00',
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   // elevation: 0,
        //   // backgroundColor: Colors.transparent,
        //   onPressed: () {},
        //   child: Text("data"),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

Widget _buildFoodItem({
  BuildContext? context,
  required String imgPath,
  required String foodName,
  required String price,
}) {
  void onTapFunction() {
    Navigator.of(context!).push(MaterialPageRoute(
        builder: (context) => DetailsPage(
            heroTag: imgPath, foodName: foodName, foodPrice: price)));
  }

  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
    child: GestureDetector(
      onTap: onTapFunction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: [
            Hero(
              tag: imgPath,
              child: Image(
                image: AssetImage(imgPath),
                fit: BoxFit.cover,
                height: 75.0,
                width: 75.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(foodName,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ])
          ]),
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {},
          )
        ],
      ),
    ),
  );
}
