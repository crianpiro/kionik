import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/services/database_service.dart';

class AddReportPage extends StatefulWidget {

  static final route = 'addReport';

  @override
  _AddReportPageState createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {

  String progress = '';

  String uid;
  String evidence;
  String rolId;
  // String date = '2020-05-04';
  String date = DateTime.now().toString().split(' ')[0];


  bool _loading = false;
  File photoF;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final List args = ModalRoute.of(context).settings.arguments;
    uid = args[0];
    evidence = args[1];
    rolId = args[2];



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Actualizar progreso'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
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
          SizedBox(height: 50.0,),
          buildLabel('Progreso', size),
          InputWidget(
            passIcon: false, 
            size: size, 
            initial: progress, 
            keyboardType: TextInputType.number, 
            onChangeF: (v){
              setState(() {
                progress = v;
              });
            }, 
            validatorF: (v){
              if(v.length <1){
                        return "Este campo es necesario";
                      }else{
                        return null;
                      }
            }, 
            hintT: 'Ingresa el avance'
          ),
          buildLabel('Agregar Evidencia', size),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(5.0),
                color: Colors.deepOrange[200],
                child: Icon(Icons.add_a_photo,color: Colors.white,size:40.0), 
                onPressed: _takePhoto
              ),
              SizedBox(width: 20.0,),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(5.0),
                color: Colors.deepOrange[200],
                child: Icon(Icons.photo_library,color: Colors.white,size:40.0), 
                onPressed: _selectPhoto
              )
            ],
          ),
          (photoF!=null)?_buildSelectedFile(size):Container(),
          buildButton(size, 'Guardar progreso', _submit)
        ],
      ),
    );

  }

  Widget _buildSelectedFile(Size size){
    return Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Archivo seleccionado',style: TextStyle(color: Colors.deepOrange,fontSize: 18.0),),
          Icon(Icons.check_circle_outline, color: Colors.deepOrange,),
        ],
      ),
    );
  }

  void _selectPhoto() {
    _processImage(ImageSource.gallery);
  }

  void _takePhoto() {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource type) async {
    photoF = await ImagePicker.pickImage(
      source: type,
    );

    if (photoF != null) {
      setState(() {});
    }
  }

  void _submit() async{

    final size = MediaQuery.of(context).size;
    
    if(!formKey.currentState.validate())return;
    
    setState(() {
      _loading = true;
    });

    if(photoF!=null){
      final resp = await DatabaseService().uploadImage(photoF, DateTime.now().microsecondsSinceEpoch.toString());
      if(resp['resolve']){
        evidence = resp['url'];
        final response = await DatabaseService().updateProgress(uid, date, evidence, progress,rolId);
        // print(response);
        if(response['resolve']){
          Navigator.pop(context);
        }else{
          buildAlert(context, Text(response['message']), 
            buildButton(size, 'Cerrar', ()=>Navigator.pop(context))
          );
        }
      }else{
        buildAlert(context, Text(resp['message']), 
          buildButton(size, 'Cerrar', ()=>Navigator.pop(context))
        );
      }
    }else{
      final response = await DatabaseService().updateProgress(uid, date, evidence, progress,rolId);
        if(response['resolve']){
          Navigator.pop(context);
        }else{
          buildAlert(context, Text(response['message']), 
            buildButton(size, 'Cerrar', ()=>Navigator.pop(context))
          );
        }

    }

  }
}