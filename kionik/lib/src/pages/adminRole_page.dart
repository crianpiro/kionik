import 'package:flutter/material.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/pages/adminAddRole_page.dart';
import 'package:kionik/src/services/database_service.dart';

class AdminRolePage extends StatefulWidget {

  static final route = 'adminRole';

  @override
  _AdminRolePageState createState() => _AdminRolePageState();
}

class _AdminRolePageState extends State<AdminRolePage> {

  bool _loading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Roles'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          _buildBody(size),
          (_loading) ? buildLoading(size) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, AddRolePage.route);
        },
      ),
    );
  }


  Widget _buildBody(Size size){

    return FutureBuilder(
      future: DatabaseService().getRoles(),
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){

        List<Widget> items = new List();

        if(snapshot.hasData){
          final Map body = snapshot.data['body'];
          body.forEach((id,item){
            items.add(_buildCard(item,size));
          });
          return ListView(
            children: items,
          );
        }else{
          return buildLoading(size);
        }
      },
    );

  }

  Widget _buildCard(Map<String,dynamic> body, Size size){
    return Card(
      
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.assignment_ind,size: 40.0,color:Colors.deepOrange),
            SizedBox(width: 5.0,),
            Container(
              width: size.width*0.8,
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                text: TextSpan(
                  text: body['roleName']+'\n',
                  style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 18.0),
                  children: [
                    TextSpan(
                      style: TextStyle(fontWeight: FontWeight.normal,color:Colors.black,fontSize: 18.0),
                      text: body['roleDesc']+'\n'+'Objetivo del rol: '+body['roleGoal'],
                    )
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}