import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/pages/adminHome_page.dart';
import 'package:kionik/src/pages/employerHome_page.dart';
import 'package:kionik/src/pages/register_page.dart';
import 'package:kionik/src/preferences/user_preferences.dart';
import 'package:kionik/src/services/auth_service.dart';
import 'package:kionik/src/services/database_service.dart';
import 'package:kionik/src/utils/validators.dart';

class Loginpage extends StatefulWidget {
  static final route = "login";

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  int rol = 0;
  String user;
  String passwd;

  bool obscurePasswd = true;
  bool _loading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PreferenciasUsuario _prefs = PreferenciasUsuario();

  Size size;

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
    // buildAlertNotification(context, Text('¡Hazlo ahora!'), Container());
  }

  Future _showNotification(String uid) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: 5));
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
    if (size == null) {
      size = MediaQuery.of(context).size;
    }

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
          _buildBodyLogin(size),
          (_loading) ? buildLoading(size) : Container(),
        ],
      ),
    );
  }

  Widget _buildBodyLogin(Size size) {
    final List<DropdownMenuItem<int>> roles = [
      DropdownMenuItem(
        child: Text('Seleccione un rol'),
        value: 0,
      ),
      DropdownMenuItem(
        child: Text('Administrador'),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text('Empleado'),
        value: 2,
      ),
    ];
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 50.0,
        ),
        SvgPicture.asset(
          'assets/svg/mainImage.svg',
          width: size.width * 0.5,
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
                buildLabel('Rol', size),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05, vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.deepOrange)),
                  child: DropdownButton(
                    items: roles,
                    value: rol,
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (v) {
                      setState(() {
                        rol = v;
                      });
                    },
                  ),
                ),
                buildLabel('Correo electrónico', size),
                InputWidget(
                    passIcon: false,
                    size: size,
                    initial: user,
                    keyboardType: TextInputType.text,
                    onChangeF: (v) {
                      setState(() {
                        user = v;
                      });
                    },
                    validatorF: (v) => validarCorreo(v),
                    hintT: "Ingresar correo"),
                buildLabel('Contraseña', size),
                InputWidget(
                    passIcon: true,
                    size: size,
                    obscure: obscurePasswd,
                    initial: passwd,
                    visiblePass: () {
                      setState(() {
                        obscurePasswd = !obscurePasswd;
                      });
                    },
                    keyboardType: TextInputType.text,
                    onChangeF: (v) {
                      passwd = v;
                    },
                    validatorF: (v) {
                      if (v.length < 1) {
                        return "Este campo es necesario";
                      } else {
                        return null;
                      }
                    },
                    hintT: "Ingresar contraseña"),
                buildButton(size, 'Iniciar sesión', _submit)
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            padding: EdgeInsets.all(0.0),
            color: Colors.white,
            child: Text(
              'Registrarme como empleado',
              style: TextStyle(color: Colors.deepOrange, fontSize: 18.0),
            ),
            onPressed: () {
              Navigator.pushNamed(context, RegisterPage.route);
            },
          ),
        )
      ],
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    if (rol == 0) {
      buildAlert(
          context,
          Text("Debes seleccionar un rol"),
          buildButton(
            size,
            'Cerrar',
            () {
              setState(() {
                _loading = false;
              });
              Navigator.pop(context);
            },
          ));
      return;
    }
    setState(() {
      _loading = true;
    });

    final resp = await AuthService().signIn(user, passwd);

    if (resp['resolve']) {
      final response =
          await DatabaseService().verifyAutorization(resp['uid'], rol);
      if (response['resolve']) {
        switch (rol) {
          case 1:
            _prefs.rol = 1;
            Navigator.pushReplacementNamed(context, AdminHomePage.route);
            break;
          case 2:
            _showNotification(resp['uid']);
            _prefs.rol = 2;
            Navigator.pushReplacementNamed(context, EmployerHomePage.route,
                arguments: resp['uid']);
            break;
          default:
            break;
        }
      } else {
        AuthService().signOut();
        buildAlert(
            context,
            Text(response['message']),
            buildButton(
              size,
              'Cerrar',
              () {
                setState(() {
                  _loading = false;
                });
                Navigator.pop(context);
              },
            ));
      }
    } else {
      buildAlert(
        context,
        Text(resp['message']),
        FlatButton(
          color: Colors.deepOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Text('Cerrar'),
          onPressed: () {
            setState(() {
              _loading = false;
            });
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}

class Background extends CustomPainter {
  Size initSize;
  Background({this.initSize});

  @override
  void paint(Canvas canvas, Size size) {
    if (initSize == null) {
      initSize = size;
    }

    final backgroundPainter = new Paint();

    backgroundPainter.strokeWidth = 10.0;
    backgroundPainter.style = PaintingStyle.fill;
    backgroundPainter.color = Colors.deepOrange;

    Path path = new Path();

    path.moveTo(0.0, 0.0);
    path.conicTo(initSize.width * 0.4, initSize.height * 0.4, initSize.width,
        initSize.height * 0.2, 1.0);
    path.lineTo(initSize.width, initSize.height * 0.8);
    path.conicTo(
        initSize.width * 0.9, initSize.height, 0.0, initSize.height * 0.9, 1.0);
    canvas.drawPath(path, backgroundPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
