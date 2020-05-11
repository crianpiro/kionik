import 'package:firebase_auth/firebase_auth.dart';
import 'package:kionik/src/models/employer_model.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String,dynamic>> validate()async{
    final user = await FirebaseAuth.instance.currentUser();

    if(user != null){
      return {
        "resolve":true,
        "uid":user.uid
      };
    }else{
      return {
        "resolve":false
      };
    }
  }

  // ..######..####..######...##....##.....#######..##.....##.########
  // .##....##..##..##....##..###...##....##.....##.##.....##....##...
  // .##........##..##........####..##....##.....##.##.....##....##...
  // ..######...##..##...####.##.##.##....##.....##.##.....##....##...
  // .......##..##..##....##..##..####....##.....##.##.....##....##...
  // .##....##..##..##....##..##...###....##.....##.##.....##....##...
  // ..######..####..######...##....##.....#######...#######.....##...

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  // ..######..####..######...##....##....####.##....##
  // .##....##..##..##....##..###...##.....##..###...##
  // .##........##..##........####..##.....##..####..##
  // ..######...##..##...####.##.##.##.....##..##.##.##
  // .......##..##..##....##..##..####.....##..##..####
  // .##....##..##..##....##..##...###.....##..##...###
  // ..######..####..######...##....##....####.##....##

  Future<Map<String,dynamic>> signIn(String email, String passwd)async{
    try {
      
      AuthResult result =   await _auth.signInWithEmailAndPassword(email: email.toLowerCase(), password: passwd);
      
      return  {
        "resolve":true,
        "statusCode":"100",
        "uid":result.user.uid,
      };
    } catch (e) {
      return {
        "resolve":false,
        "statusCode":"400",
        "msj":"${e.toString()}"
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

  Future<Map<String,dynamic>> signUp(EmployerModel employerModel)async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: employerModel.email, password: employerModel.passwd);


      return  {
        "resolve":true,
        "statusCode":"100",
        "uid":result.user.uid,
      };

    } catch (e) {
      return {
        "resolve":false,
        "statusCode":"400",
        "message":"${e.toString()}"
      };
    }
  }
  
}