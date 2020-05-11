import 'package:flutter/material.dart';
import 'package:kionik/src/pages/adminAddRole_page.dart';
import 'package:kionik/src/pages/adminAsignRole_page.dart';
import 'package:kionik/src/pages/adminGeneralReport_page.dart';
import 'package:kionik/src/pages/adminHome_page.dart';
import 'package:kionik/src/pages/adminReports_page.dart';
import 'package:kionik/src/pages/adminRole_page.dart';
import 'package:kionik/src/pages/employerAddReport_page.dart';
import 'package:kionik/src/pages/employerHome_page.dart';
import 'package:kionik/src/pages/login_page.dart';
import 'package:kionik/src/pages/register_page.dart';

class ApplicationRoutes {

  Map<String, WidgetBuilder> getApplicationRoutes(){
    return {
      Loginpage.route: (BuildContext context) => Loginpage(),
      AdminReportPage.route: (BuildContext context) => AdminReportPage(),
      AddReportPage.route: (BuildContext context) => AddReportPage(),
      AdminGeneralReportPage.route: (BuildContext context) => AdminGeneralReportPage(),
      RegisterPage.route: (BuildContext context) => RegisterPage(),
      AddRolePage.route: (BuildContext context) => AddRolePage(),
      AdminRolePage.route: (BuildContext context) => AdminRolePage(),
      AdminAssignRolePage.route: (BuildContext context) => AdminAssignRolePage(),
      AdminHomePage.route: (BuildContext context) => AdminHomePage(),
      EmployerHomePage.route: (BuildContext context) => EmployerHomePage(),
    };
  }
}
