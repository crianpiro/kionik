import 'package:flutter/material.dart';

// .####.##....##.########..##.....##.########
// ..##..###...##.##.....##.##.....##....##...
// ..##..####..##.##.....##.##.....##....##...
// ..##..##.##.##.########..##.....##....##...
// ..##..##..####.##........##.....##....##...
// ..##..##...###.##........##.....##....##...
// .####.##....##.##.........#######.....##...

/*
 * [Crea un input/caja de texto como textFormField]
 * @params
 *  Size size           -> Tamaño del screen para ajustar margenes y tamaño del input.
 *  Function onChangeF  -> Función para realizar cuando hay un cambio en el input.
 *  Function validatorF -> Función para validar cuando se guarda el valor del input.
 *  String hintT        -> Texto para mostrar como placeholder.
 *  
 * @return Widget
 * @author Cristian Andrés Picón
 * @Override -- 
 * @Override_Date --
 */

class InputWidget extends StatelessWidget {
  //Required
  final Size size;
  final bool passIcon;
  final String hintT;
  final String initial;
  final Function onChangeF;
  final Function validatorF;
  final TextInputType keyboardType;

  //Variables opcionales
  final bool enable;
  final bool readOnly;
  final bool obscure;
  final Function visiblePass;
  final Widget sufixIcon;

  InputWidget(
      {@required this.passIcon,
      this.sufixIcon,
      @required this.size,
      @required this.initial,
      this.enable,
      this.readOnly,
      this.obscure,
      @required this.keyboardType,
      @required this.onChangeF,
      @required this.validatorF,
      @required this.hintT,
      this.visiblePass});

  @override
  Widget build(BuildContext context) {
    bool obscureController = false;

    if (this.obscure != null) {
      obscureController = this.obscure;
    }

    final Widget sufixIcon = IconButton(
      icon: Icon(obscureController ? Icons.visibility : Icons.visibility_off,color: Colors.deepOrange,),
      onPressed: (this.visiblePass != null) ? this.visiblePass : () {},
    );

    final Widget customSufixIcon = IconButton(
      icon: (this.sufixIcon != null) ? this.sufixIcon : Container(),
      onPressed: (this.visiblePass != null) ? this.visiblePass : () {},
    );

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: this.size.width * 0.05, vertical: 5.0),
      child: TextFormField(
        initialValue: this.initial,
        keyboardType: this.keyboardType,
        readOnly: (this.readOnly != null) ? this.readOnly : false,
        enabled: (this.enable != null) ? this.enable : true,
        textCapitalization: TextCapitalization.sentences,
        obscureText: (this.obscure != null) ? this.obscure : false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(10.0)
          ),
          border: OutlineInputBorder(),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(10.0)
          ),
          hintText: this.hintT,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: (this.passIcon)
              ? sufixIcon
              : ((this.sufixIcon != null) ? customSufixIcon : null),
        ),
        autovalidate: true,
        onChanged: this.onChangeF,
        validator: this.validatorF,
      ),
    );
  }
}

// .##..........###....########..########.##......
// .##.........##.##...##.....##.##.......##......
// .##........##...##..##.....##.##.......##......
// .##.......##.....##.########..######...##......
// .##.......#########.##.....##.##.......##......
// .##.......##.....##.##.....##.##.......##......
// .########.##.....##.########..########.########

Widget buildLabel(String text,Size size){

  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.symmetric(horizontal: size.width*0.05, vertical: 10.0),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.deepOrange,
        fontSize: 18.0,
        fontWeight: FontWeight.bold
      ),
    ),
  );

}

// .########..##.....##.########.########..#######..##....##
// .##.....##.##.....##....##.......##....##.....##.###...##
// .##.....##.##.....##....##.......##....##.....##.####..##
// .########..##.....##....##.......##....##.....##.##.##.##
// .##.....##.##.....##....##.......##....##.....##.##..####
// .##.....##.##.....##....##.......##....##.....##.##...###
// .########...#######.....##.......##.....#######..##....##

Widget buildButton(Size size, String text, Function onPressedF){
  return Container(
    height: 50.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0)
    ),
    margin: EdgeInsets.symmetric(horizontal: size.width*0.05,vertical: 10.0),
    child: FlatButton(
      disabledColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      padding: EdgeInsets.all(10.0),
      color: Colors.deepOrange,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        ),
      ),
      onPressed:onPressedF),
  );
}

// ....###....##.......########.########..########
// ...##.##...##.......##.......##.....##....##...
// ..##...##..##.......##.......##.....##....##...
// .##.....##.##.......######...########.....##...
// .#########.##.......##.......##...##......##...
// .##.....##.##.......##.......##....##.....##...
// .##.....##.########.########.##.....##....##...

  void buildAlert(BuildContext context,Widget content,Widget button){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title:  Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline,
                  size: 40.0,
                  color: Colors.deepOrangeAccent,
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¡Un momento!',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),
               
              ],
            ),
          content: content,
          actions: <Widget>[
             button,
          ],
        );
      },
    );
  }

   void buildAlertNotification(BuildContext context,Widget content,Widget button){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title:  Container(
                  margin: EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¿Ya registraste tu progreso?',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ),
          content: content,
          actions: <Widget>[
             button,
          ],
        );
      },
    );
  }


  // .##........#######.....###....########..####.##....##..######..
  // .##.......##.....##...##.##...##.....##..##..###...##.##....##.
  // .##.......##.....##..##...##..##.....##..##..####..##.##.......
  // .##.......##.....##.##.....##.##.....##..##..##.##.##.##...####
  // .##.......##.....##.#########.##.....##..##..##..####.##....##.
  // .##.......##.....##.##.....##.##.....##..##..##...###.##....##.
  // .########..#######..##.....##.########..####.##....##..######..

  Widget buildLoading(Size size){

     final Animation<Color> valueColor = AlwaysStoppedAnimation<Color>(Colors.amber);

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Center(
        child: Container(
          width: size.width*0.15,
          height: size.width*0.15,
          child: CircularProgressIndicator(
          backgroundColor: Colors.deepOrange,
          strokeWidth: 8.0,
          valueColor: valueColor,
        ),
        )
      ),
    );
  }