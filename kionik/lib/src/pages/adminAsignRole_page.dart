import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/services/database_service.dart';

class AdminAssignRolePage extends StatefulWidget {

  static final route = 'adminAssignRole';

  @override
  _AdminAssignRolePageState createState() => _AdminAssignRolePageState();
}

class _AdminAssignRolePageState extends State<AdminAssignRolePage> {

  bool _loading = false;

  Map<String,String> employersRoles = {
    "none":"Seleccione un rol"
  };

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Asignar Roles'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          _buildBody(size),
          (_loading) ? buildLoading(size) : Container(),
        ],
      ),
      floatingActionButton: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        color: Colors.deepOrange,
        child: Text('Guardar Cambios', style: TextStyle(fontSize: 18.0,color:Colors.white),),
        onPressed: _submit,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(Size size){
    return FutureBuilder(
      future: DatabaseService().getEmployers(),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){

        List<Widget> items = new List();

        if(snapshot.hasData){
          final Map body = snapshot.data['body'];

          body.forEach((id,item){
            items.add(_buildCard(size, item, id));
          });

          return ListView(
            children: items,
          );
        }else{
          return buildLoading(size);
        }
        
      }
    );


  }

  Widget _buildCard(Size size,Map body, String id){
    
    if(employersRoles[id]==null){
      if(body['rol']!=null){
        employersRoles[id] = body['rol'];
      }else{
        employersRoles[id] = "none";
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text('Nombre empleado:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
            title: Text(body['name'],style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16.0)),
          ),
          ListTile(
            leading: Text('Email empleado:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
            title: Text(body['email'],style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16.0)),
          ),
          _buildSelector(size, id)
        ],
      ),
    );
  }


  Widget _buildSelector(Size size, String id){

    return FutureBuilder(
      future: DatabaseService().getRoles(),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){

        List<DropdownMenuItem<dynamic>> items = new List();



        if(snapshot.hasData){
          items.add(_buildItem({
            "roleName":"Seleccione un rol"
          }, "none"));
          final Map body = snapshot.data['body'];
          body.forEach((id,item){
            items.add(_buildItem(item,id));
          });
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.deepOrange)
                  ),
            margin: EdgeInsets.symmetric(horizontal: size.width*0.05,vertical: 10.0),
            child: DropdownButton(
              underline: Container(),
              isExpanded: true,
              items: items,
              value: employersRoles[id],
              onChanged: (v){
                setState(() {
                  employersRoles[id] = v;
                });
              }
            ),
          );
        }else{
          return buildLoading(size);
        }
      },
    );

  }

  Widget _buildItem(Map<String,dynamic> body, String id){

    return DropdownMenuItem(
      child: Text(body['roleName'],style: TextStyle(fontSize: 18.0),),
      value: id,
    );
    
  }

  void _submit() async{

    final size = MediaQuery.of(context).size;

    setState(() {
      _loading = true;
    });

    final resp = await DatabaseService().setRoles(employersRoles);

    if(resp['resolve']){
      Timer(Duration(milliseconds: 100), (){
        setState(() {
      _loading = false;
      });
      });
    }else{
      setState(() {
      _loading = false;
      });
      buildAlert(context, Text(resp['message']),
        buildButton(size, 'Cerrar', ()=>Navigator.pop(context))
      );
    }
    
  }

}