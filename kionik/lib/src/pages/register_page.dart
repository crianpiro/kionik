import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/models/employer_model.dart';
import 'package:kionik/src/pages/employerHome_page.dart';
import 'package:kionik/src/pages/login_page.dart';
import 'package:kionik/src/services/database_service.dart';
import 'package:kionik/src/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  static final route = 'register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  EmployerModel employerModel = EmployerModel();

  bool _loading = false;
  bool obscurePasswd = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  }

  Future onSelectNotification(String payload) async {
    // buildAlertNotisfication(context, Text('¡Hazlo ahora!'), Container());
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
        payload: uid);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            child: CustomPaint(
              painter: Background(initSize: size),
            ),
          ),
          buildBodyRegister(size),
          (_loading) ? buildLoading(size) : Container(),
        ],
      ),
    );
  }

  Widget buildBodyRegister(Size size) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 50.0,
        ),
        SvgPicture.asset(
          'assets/svg/mainImage.svg',
          width: 200.0,
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                buildLabel('Nombre', size),
                InputWidget(
                    passIcon: false,
                    size: size,
                    initial: employerModel.name,
                    keyboardType: TextInputType.text,
                    onChangeF: (v) {
                      setState(() {
                        employerModel.name = v;
                      });
                    },
                    validatorF: (v) {
                      if (v.length < 1) {
                        return "Este campo es necesario";
                      } else {
                        return null;
                      }
                    },
                    hintT: 'Ingresar nombre'),
                buildLabel('Correo electrónico', size),
                InputWidget(
                    passIcon: false,
                    size: size,
                    initial: employerModel.email,
                    keyboardType: TextInputType.text,
                    onChangeF: (v) {
                      setState(() {
                        employerModel.email = v;
                      });
                    },
                    validatorF: (v) => validarCorreo(v),
                    hintT: 'Ingresar correo'),
                buildLabel('Contraseña', size),
                InputWidget(
                    passIcon: true,
                    obscure: obscurePasswd,
                    visiblePass: () {
                      setState(() {
                        obscurePasswd = !obscurePasswd;
                      });
                    },
                    size: size,
                    initial: employerModel.passwd,
                    keyboardType: TextInputType.text,
                    onChangeF: (v) {
                      setState(() {
                        employerModel.passwd = v;
                      });
                    },
                    validatorF: (v) {
                      if (v.length < 1) {
                        return "Este campo es necesario";
                      } else {
                        return null;
                      }
                    },
                    hintT: 'Ingresar contraseña'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildButton(size, 'Volver', () {
                      Navigator.pop(context);
                    }),
                    buildButton(size, 'Registrarme', submit),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void submit() async {
    final size = MediaQuery.of(context).size;

    if (!formKey.currentState.validate()) return;

    setState(() {
      _loading = true;
    });

    final response = await DatabaseService().signUpEmployer(employerModel);

    if (response['resolve']) {
      _showNotification(response['uid']);
      Navigator.pushNamedAndRemoveUntil(
          context,
          EmployerHomePage.route,
          ModalRoute.withName(
            EmployerHomePage.route,
          ),
          arguments: response['uid']);
    } else {
      setState(() {
        _loading = false;
      });
      buildAlert(context, Text(response['message']),
          buildButton(size, 'Cerrar', () => Navigator.pop(context)));
    }
  }
}
