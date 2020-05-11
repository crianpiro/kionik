import 'package:flutter/material.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/services/database_service.dart';

class AddRolePage extends StatefulWidget {

  static final route = 'addRole';

  @override
  _AddRolePageState createState() => _AddRolePageState();
}

class _AddRolePageState extends State<AddRolePage> {

  String roleName = '';
  String roleDesc = '';
  String roleGoal = '';

  bool _loading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Agregar Rol'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          _buildBody(size),
          (_loading) ? buildLoading(size) : Container(),
        ],
      )
    );
  }


  Widget _buildBody(Size size){

    return Form(
      key: formKey,
      child: ListView(
        children: <Widget>[
          buildLabel('Nombre', size),
          InputWidget(
            passIcon: false, 
            size: size, 
            initial: roleName, 
            keyboardType: TextInputType.text, 
            onChangeF: (v){
              setState(() {
                roleName = v;
              });
            }, 
            validatorF: (v){
              if(v.length <1){
                        return "Este campo es necesario";
                      }else{
                        return null;
                      }
            }, 
            hintT: 'Ingresa nombre del rol'
          ),
          buildLabel('Descripción', size),
          InputWidget(
            passIcon: false, 
            size: size, 
            initial: roleDesc, 
            keyboardType: TextInputType.text, 
            onChangeF: (v){
              setState(() {
                roleDesc = v;
              });
            }, 
            validatorF: (v){
              if(v.length <1){
                        return "Este campo es necesario";
                      }else{
                        return null;
                      }
            }, 
            hintT: 'Ingresa la descripción del rol'
          ),
          buildLabel('Objetivo diario', size),
          InputWidget(
            passIcon: false, 
            size: size, 
            initial: roleGoal, 
            keyboardType: TextInputType.number, 
            onChangeF: (v){
              setState(() {
                roleGoal = v;
              });
            }, 
            validatorF: (v){
              if(v.length <1){
                        return "Este campo es necesario";
                      }else{
                        return null;
                      }
            }, 
            hintT: 'Ingresa el objetivo diario del rol'
          ),
          buildButton(size, 'Guardar Rol', _submit)
        ],
      ),
    );

  }

  void _submit() async{

    final size = MediaQuery.of(context).size;
    
    if(!formKey.currentState.validate())return;
    
    setState(() {
      _loading = true;
    });

    final resp = await DatabaseService().addRole(roleName, roleDesc, roleGoal);
    
    if(resp['resolve']){
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);
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