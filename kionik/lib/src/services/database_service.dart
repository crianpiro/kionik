
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kionik/src/models/employer_model.dart';
import 'package:kionik/src/services/auth_service.dart';


class DatabaseService {

  static final Firestore firestoreInstance = Firestore.instance;

  final CollectionReference  _adminsCollection    = firestoreInstance.collection('admins');
  final CollectionReference  _employersCollection = firestoreInstance.collection('employers');
  final CollectionReference  _rolesCollection = firestoreInstance.collection('roles');
  final CollectionReference  _progressCollection = firestoreInstance.collection('reports');

  // .########.##.....##.####.########..########.##....##..######..########..######.
  // .##.......##.....##..##..##.....##.##.......###...##.##....##.##.......##....##
  // .##.......##.....##..##..##.....##.##.......####..##.##.......##.......##......
  // .######...##.....##..##..##.....##.######...##.##.##.##.......######....######.
  // .##........##...##...##..##.....##.##.......##..####.##.......##.............##
  // .##.........##.##....##..##.....##.##.......##...###.##....##.##.......##....##
  // .########....###....####.########..########.##....##..######..########..######.

  Future<Map<String,dynamic>> uploadImage(File file, String filename)async {

    try {
      String downLoadUrl;

      StorageReference storageReference = FirebaseStorage.instance.ref().child('evidences/$filename');

      StorageUploadTask uploadTask = storageReference.putFile(file);

      final resp = await uploadTask.onComplete;

      if(resp.error != null){
        return {
          "resolve":false,
          "message":resp.error.toString(),
        };
      }
      downLoadUrl =  await storageReference.getDownloadURL();

      return {
        "resolve":true,
        "url":downLoadUrl
      };

    } catch (e) {
      return {
        "resolve":false,
        "message":e.toString(),
      };
    }

   

  }

  // .########..########...#######...######...########..########..######...######.
  // .##.....##.##.....##.##.....##.##....##..##.....##.##.......##....##.##....##
  // .##.....##.##.....##.##.....##.##........##.....##.##.......##.......##......
  // .########..########..##.....##.##...####.########..######....######...######.
  // .##........##...##...##.....##.##....##..##...##...##.............##.......##
  // .##........##....##..##.....##.##....##..##....##..##.......##....##.##....##
  // .##........##.....##..#######...######...##.....##.########..######...######.

  Future<Map<String,dynamic>> getProgress(String uid, String date)async{
    try {
      final resp = await _progressCollection.document(uid).get();

      if(resp.exists){
        if(resp.data[date]!=null){
          return {
        "resolve":true,
        "body": resp.data[date],
      };
        }else{
          return {
        "resolve":false,
        "statusCode":999,
        "message": "No hay progreso registrado para el dia actual",
      };
        }
        
      }else{  
        return {
        "resolve":false,
        "message": "Error inesperado",
      };
      }

    } catch (e) {
       return {
        "resolve":false,
        "message": e.toString(),
      };
    }

  }

    Future<Map<String,dynamic>> updateProgress(String uid, String date, String evidence, String progress,String rolId)async{
    try {


      await _progressCollection.document(uid).updateData({
        date:{
          "rolId":rolId,
          "evidence":evidence,
          "progress":progress,
        }
      }).catchError((e){
        return {
        "resolve":false,
        "message": e.toString(),
      };
      });

      return {
        "resolve":true,
      };

    } catch (e) {
       return {
        "resolve":false,
        "message": e.toString(),
      };
    }

  }


  // .########.##.....##.########..##........#######..##....##.########.########...######.
  // .##.......###...###.##.....##.##.......##.....##..##..##..##.......##.....##.##....##
  // .##.......####.####.##.....##.##.......##.....##...####...##.......##.....##.##......
  // .######...##.###.##.########..##.......##.....##....##....######...########...######.
  // .##.......##.....##.##........##.......##.....##....##....##.......##...##.........##
  // .##.......##.....##.##........##.......##.....##....##....##.......##....##..##....##
  // .########.##.....##.##........########..#######.....##....########.##.....##..######.

  Future<Map<String,dynamic>> getEmployer(String uid)async{
    try {
      final resp = await _employersCollection.document(uid).get();

      if(resp.exists){
        return {
        "resolve":true,
        "body":resp.data,
      };
      }else{
        return {
        "resolve":false,
        "message": "Error",
      };
      }
      
    } catch (e) {
      return {
        "resolve":false,
        "message": e.toString(),
      };
    }
  }


  Future<Map<String,dynamic>> setRoles(Map roles)async{
    try {
      roles.forEach((id,role)async{
        if(id!='none'){
          await _employersCollection.document(id).updateData({
          "rol":role,
        });
        }
      });
      return {
        "resolve":true,
      };   
      
    } catch (e) {
       return {
        "resolve":false,
        "message": e.toString(),
      };
    }

  }


  Future<Map<String,dynamic>> getEmployers()async{
    try { 
      Map<String,dynamic> result = new Map<String,dynamic>();

      final resp = await _employersCollection.getDocuments();
      for (var item in resp.documents) {
        result[item.documentID]=item.data;
      }

      return {
        "resolve":true,
        "body":result
      };
    } catch (e) {
      return {
        "resolve":false,
        "message": e.toString(),
      };
    }
  }


  // .########...#######..##.......########..######.
  // .##.....##.##.....##.##.......##.......##....##
  // .##.....##.##.....##.##.......##.......##......
  // .########..##.....##.##.......######....######.
  // .##...##...##.....##.##.......##.............##
  // .##....##..##.....##.##.......##.......##....##
  // .##.....##..#######..########.########..######.

   Future<Map<String,dynamic>> getRol(String rolId)async{
    try { 

      final resp = await _rolesCollection.document(rolId).get();

      if(resp.data!=null){
        return {
        "resolve":true,
        "body":resp.data
      };
      }else{
        return {
        "resolve":false,
        "statusCode":999,
        "message": "Aún no te han asignado un rol de empleado, comunicate con el administrador.",
      };
      }
    } catch (e) {
      return {
        "resolve":false,
        "message": e.toString(),
      };
    }
  }


  Future<Map<String,dynamic>> getRoles()async{
    try { 
      Map<String,dynamic> result = new Map<String,dynamic>();

      final resp = await _rolesCollection.getDocuments();
      for (var item in resp.documents) {
        result[item.documentID]=item.data;
      }

      return {
        "resolve":true,
        "body":result
      };
    } catch (e) {
      return {
        "resolve":false,
        "message": e.toString(),
      };
    }
  }


  Future<Map<String,dynamic>> addRole(String roleName, String roleDesc,String roleGoal)async{
    try {
      await _rolesCollection.document().setData({
        "roleName":roleName,
        "roleDesc":roleDesc,
        "roleGoal":roleGoal,
      });

      return {
        "resolve":true,
      };

    } catch (e) {
       return {
        "resolve":false,
        "message": e.toString(),
      };
    }
  }

  // ....###....##.....##.########..#######..########..####.########....###....########.####..#######..##....##
  // ...##.##...##.....##....##....##.....##.##.....##..##.......##....##.##......##.....##..##.....##.###...##
  // ..##...##..##.....##....##....##.....##.##.....##..##......##....##...##.....##.....##..##.....##.####..##
  // .##.....##.##.....##....##....##.....##.########...##.....##....##.....##....##.....##..##.....##.##.##.##
  // .#########.##.....##....##....##.....##.##...##....##....##.....#########....##.....##..##.....##.##..####
  // .##.....##.##.....##....##....##.....##.##....##...##...##......##.....##....##.....##..##.....##.##...###
  // .##.....##..#######.....##.....#######..##.....##.####.########.##.....##....##....####..#######..##....##

  Future<Map<String,dynamic>> verifyAutorization(String uid, int rol)async{
    try {

      switch (rol) {
        case 1:
          final resp = await _adminsCollection.document(uid).get();
          if(resp.exists){
            return {
              "resolve":resp.exists,
              "body": resp.data
            };
          }else{
            return {
              "resolve":resp.exists,
              "message": "No tiene autorización como administrador."
            };
          }
          break;
        case 2:
          final resp = await _employersCollection.document(uid).get();
          if(resp.exists){
            return {
              "resolve":resp.exists,
              "body": resp.data
            };
          }else{
            return {
              "resolve":resp.exists,
              "message": "No tiene autorización como empleado."
            };
          }
          break;
        default:
          return {
              "resolve":false,
              "message": "Error inesperado."
            };
          break;
      }
      

    } catch (e) {
      return {
        "resolve":false,
        "message": e.toString(),
      };
    }
  }

  // ..######..####..######...##....##....##.....##.########.
  // .##....##..##..##....##..###...##....##.....##.##.....##
  // .##........##..##........####..##....##.....##.##.....##
  // ..######...##..##...####.##.##.##....##.....##.########.
  // .......##..##..##....##..##..####....##.....##.##.......
  // .##....##..##..##....##..##...###....##.....##.##.......
  // ..######..####..######...##....##.....#######..##.......

   Future<Map<String,dynamic>> signUpEmployer(EmployerModel employerModel) async{
     try {

       final respSignUp = await AuthService().signUp(employerModel);
       if(respSignUp['resolve']){
         await _employersCollection.document(respSignUp['uid']).setData({
           "name":employerModel.name,
           "email":employerModel.email,
         }).catchError((e){
           return {
            "resolve":false,
            "message": e.toString(),
          };
         });

         await _progressCollection.document(respSignUp['uid']).setData({});

         return {
           "resolve":true,
           "uid":respSignUp['uid']
         };
       }else{
         return {
          "resolve":false,
          "message":respSignUp['message'],
        };
       }
       
     } catch (e) {
       return {
        "resolve":false,
        "message": e.toString(),
      };
     }
   }

  
}