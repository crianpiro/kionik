import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/pages/adminAsignRole_page.dart';
import 'package:kionik/src/pages/adminGeneralReport_page.dart';
import 'package:kionik/src/pages/adminReports_page.dart';
import 'package:kionik/src/pages/adminRole_page.dart';
import 'package:kionik/src/pages/login_page.dart';
import 'package:kionik/src/services/auth_service.dart';

class AdminHomePage extends StatefulWidget {
  
  static final route = "adminHome";

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  @override
  Widget build(BuildContext context) {

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
          _buildBodyHome(size),
        ],
      )
    );
  }

  Widget _buildBodyHome(Size size){

    return ListView(
      children: <Widget>[
        SizedBox(height: 50.0,),
        SvgPicture.asset('assets/svg/mainImage.svg',width: 200.0,),
        Divider(thickness: 1.0,),
        _buildListTile(Icons.assignment_ind, Text('Roles de empleados',style: TextStyle(fontSize: 18.0),), (){
          Navigator.pushNamed(context, AdminRolePage.route);
        }),
        Divider(thickness: 1.0,),
        _buildListTile(Icons.transfer_within_a_station, Text('Asignar roles',style: TextStyle(fontSize: 18.0),), (){
          Navigator.pushNamed(context, AdminAssignRolePage.route);
        }),
        Divider(thickness: 1.0,),
        _buildListTile(Icons.pie_chart, Text('Informes especificos',style: TextStyle(fontSize: 18.0),), (){
          Navigator.pushNamed(context, AdminReportPage.route);
        }),
         Divider(thickness: 1.0,),
        _buildListTile(Icons.table_chart, Text('Informes generales',style: TextStyle(fontSize: 18.0),), (){
          Navigator.pushNamed(context, AdminGeneralReportPage.route);
        }),
        Divider(thickness: 1.0,),
        buildButton(size, "Cerrar sesión", ()async{
            AuthService().signOut();
            Navigator.pushReplacementNamed(context, Loginpage.route);
          })
      ],
    );

  }

  Widget _buildListTile(IconData icon,Widget content,Function onPressedF){

    return ListTile(     
      leading: Icon(icon,color: Colors.deepOrange,size: 30.0,),
      title: content,
      trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepOrange,),
      onTap: onPressedF,
    );

  }
}