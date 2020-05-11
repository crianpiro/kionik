import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/pages/employerAddReport_page.dart';
import 'package:kionik/src/pages/login_page.dart';
import 'package:kionik/src/services/auth_service.dart';
import 'package:kionik/src/services/database_service.dart';

class EmployerHomePage extends StatefulWidget {
  static final route = "empHome";

  @override
  _EmployerHomePageState createState() => _EmployerHomePageState();
}

class _EmployerHomePageState extends State<EmployerHomePage> {

  bool _loading = false;

  String uid;
  // String date = '2020-05-04';
  String date = DateTime.now().toString().split(' ')[0];
  String time = DateTime.now().toString().split(' ')[1].split('.')[0];

  bool _enabledUpdate = true;
  bool _roolAssigned = true;


  @override
  Widget build(BuildContext context) {


    uid = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Inicio'),
          leading: Container(),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            _buildBody(size),
            (_loading) ? buildLoading(size) : Container(),
          ],
        ));
  }

  Widget _buildBody(Size size) {
    return FutureBuilder(
      future: DatabaseService().getEmployer(uid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final Map body = snapshot.data;
          if (body['resolve']) {
            final data = body['body'];
            return ListView(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    buildLabel("Nombres: ", size),
                    Text(
                      data['name'],
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    buildLabel("Email: ", size),
                    Text(
                      data['email'],
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
                _buildRolInfo(size, data['rol']),
                _buildProgressInfo(size, data['rol']),
                buildButton(size, "Cerrar sesión", () async {
                  AuthService().signOut();
                  Navigator.pushReplacementNamed(context, Loginpage.route);
                })
              ],
            );
          } else {
            return buildLoading(size);
          }
        } else {
          return buildLoading(size);
        }
      },
    );
  }

  Widget _buildRolInfo(Size size, String rolId) {
    return FutureBuilder(
        future: DatabaseService().getRol(rolId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // print(snapshot.data);
          if (snapshot.hasData) {
            if (snapshot.data['resolve']) {
              final data = snapshot.data['body'];

              return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.deepOrange[50],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Rol de empleado',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        buildLabel('Rol: ', size),
                        Text(
                          data['roleName'],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildLabel('Descripción: ', size),
                        Container(
                          width: size.width*0.5,
                          child: Text(
                            data['roleDesc'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildLabel('Objetivo: ', size),
                        Text(
                          data['roleGoal'],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              if(snapshot.data['statusCode']==999){
                _roolAssigned = false;
                return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.deepOrange[50],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Rol de empleado',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                          width: size.width*0.8,
                          child: Text(
                            snapshot.data['message'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                  ],
                ),
              );
              }else{
                return buildLoading(size);
              }
            }
          } else {
            return buildLoading(size);
          }
        });
  }

  Widget _buildProgressInfo(Size size, String rolId) {
    return FutureBuilder(
        future: DatabaseService().getProgress(uid, date),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data);
            if (snapshot.data['resolve']) {
              final data = snapshot.data['body'];

              return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Mi Progreso',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        buildLabel('Día: ', size),
                        Text(
                          date,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildLabel('Progreso: ', size),
                        Text(
                          data['progress'],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    buildLabel('Evidencias: ', size),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage(
                        width: 200.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/png/loading.png'),
                        image: NetworkImage(data['evidence']),
                      ),
                    ),
                    buildButton(size, "Actualizar progreso", ()=>Navigator.pushNamed(context, AddReportPage.route,arguments: [uid,data['evidence'],rolId])),

                  ],
                ),
              );
            } else {
              if(snapshot.data['statusCode']==999){
                return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildLabel('Progreso: ', size),
                    buildButton(size, "Registrar progreso", (_roolAssigned)?()=>Navigator.pushNamed(context, AddReportPage.route,arguments: [uid,'',rolId]):null ),
                  ],
                ),
              ); 
              }else{
                return buildLoading(size);
              }
            }
          } else {
            return buildLoading(size);
          }
        });
  }
}
