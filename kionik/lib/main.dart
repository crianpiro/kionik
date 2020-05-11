import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/pages/adminHome_page.dart';
import 'package:kionik/src/pages/employerHome_page.dart';
import 'package:kionik/src/pages/login_page.dart';
import 'package:kionik/src/preferences/user_preferences.dart';
import 'package:kionik/src/routes/routes.dart';
import 'package:kionik/src/services/auth_service.dart';

void main() async {
  runApp(MyApp());

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      title: 'Kionik Proof',
      home: SplashScreen(),
      routes: ApplicationRoutes().getApplicationRoutes(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    initApp();
  }

  Future onSelectNotification(String payload) async {
    // buildAlertNotification(context, Text('¡Hazlo ahora!'), Container());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: buildLoading(size),
    );
  }

  Future<Timer> initApp() async {
    // return new Timer(Duration(seconds: 1), (){
    //   _showNotificationWithDefaultSound();
    // });
    return new Timer(Duration(seconds: 1), validateSession);
  }

  Future _showNotification(String uid) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Kionik Channel Id', 'Kionik Channel', 'Kionik Description',importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      '¿Ya registraste tu progreso?',
      '¡Hazlo ahora!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: uid,
    );

    //Show notification instantly
    // var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    //     'your channel id', 'your channel name', 'your channel description',
    //     importance: Importance.Max, priority: Priority.High);
    // var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    // var platformChannelSpecifics = new NotificationDetails(
    //     androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   'New Post',
    //   'How to Show Notification in Flutter',
    //   platformChannelSpecifics,
    //   payload: 'Default_Sound',
    // );
  }

  validateSession() async {
    final _session = await _authService.validate();

    if (_session['resolve']) {
      if (_prefs.rol != 0) {
        switch (_prefs.rol) {
          case 1:
            Navigator.pushReplacementNamed(context, AdminHomePage.route,
                arguments: _session['uid']);
            break;
          case 2:
            _showNotification(_session['uid']);
            Navigator.pushReplacementNamed(context, EmployerHomePage.route,
                arguments: _session['uid']);
            break;
          default:
        }
      } else {
        Navigator.pushReplacementNamed(context, Loginpage.route);
      }
    } else {
      Navigator.pushReplacementNamed(context, Loginpage.route);
    }
  }
}
