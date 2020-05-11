
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class CircularGraphWidget extends StatefulWidget {

  final double percent;
  final bool label;
  final Color labelColor;
  final double labelSize;
  final double progressWidth;
  final Color progressColor;
  final double roadWidth;
  final Color roadColor;
  final bool fill;
  final bool labelBold;
  final bool fillProgress;


  CircularGraphWidget({
    @required this.percent,
    @required this.label,
    @required this.fill,
    @required this.fillProgress,
    this.progressWidth,
    this.labelColor,
    this.labelBold,
    this.labelSize,
    this.progressColor,
    this.roadWidth,
    this.roadColor,
  });

  @override
  _CircularGraphWidgetState createState() => _CircularGraphWidgetState();
}

class _CircularGraphWidgetState extends State<CircularGraphWidget> with SingleTickerProviderStateMixin {

  AnimationController arcAnimationController;
  double oldPercent;

  @override
  void initState() { 

    oldPercent = widget.percent;
    arcAnimationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    
    super.initState();
    
  }

  @override
  void dispose() { 
    
    arcAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    arcAnimationController.forward(from: 0.0);

    final avance =  widget.percent - oldPercent;
    oldPercent = widget.percent;



    return AnimatedBuilder(
      animation: arcAnimationController,
      builder: (BuildContext context, Widget child){
        return Stack(
          children: <Widget>[
          Container(
           width: double.infinity,
           height: double.infinity,
           child: CustomPaint(
             painter: _RadialProgress(
               percent:(widget.percent-avance)+(avance*arcAnimationController.value),
               fill: widget.fill,
               fillProgress: widget.fillProgress,
               progressColor: (widget.progressColor != null) ? widget.progressColor : Colors.lightBlue,
               progressWidth: ( widget.progressWidth != null)? widget.progressWidth: 15.0,
               roadWidth: (widget.roadWidth != null)?widget.roadWidth:3.0,
               roadColor: (widget.roadColor != null)?widget.roadColor:Colors.grey,
            ),
           ),
        ),
        (widget.label)?
          Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
            child: Text(
              '${widget.percent.toInt().toString()}%',
              style: TextStyle(
                color: (widget.labelColor != null) ? widget.labelColor: Colors.grey,
                fontSize: (widget.labelSize != null) ? widget.labelSize: 16.0,
                fontWeight: (widget.labelBold != null && widget.labelBold) ? FontWeight.bold: FontWeight.normal,
              ),),
          ):Container(),
          ],
        );
      },
    );
  }
}

class _RadialProgress extends CustomPainter {

  final double percent;
  final double progressWidth;
  final Color progressColor;
  final double roadWidth;
  final Color roadColor;
  final bool fill;
  final bool fillProgress;

  _RadialProgress({
    @required this.percent,
    @required this.fill,
    @required this.fillProgress,
    this.progressWidth,
    this.progressColor,
    this.roadWidth,
    this.roadColor,
  });

  @override
  void paint(Canvas canvas, Size size) {

    //Circle Painter
    final circlePainter = new Paint();

    circlePainter.strokeWidth = (roadWidth != null) ? roadWidth : 3;
    circlePainter.color = (roadColor != null) ? roadColor : Colors.grey;
    circlePainter.style =(fill) ? PaintingStyle.fill : PaintingStyle.stroke;

    final Offset center = new Offset(size.width*0.5, size.height*0.5);
    final double radio = math.min(size.width*0.5,size.height*0.5);

    canvas.drawCircle(center, radio, circlePainter  );

    //Arc Painter

    final arcPainter = new Paint();

    arcPainter.strokeCap = StrokeCap.round;
    arcPainter.strokeWidth = (progressWidth != null) ? progressWidth : 10;
    arcPainter.color =(progressColor != null) ? progressColor : Colors.amber;
    arcPainter.style =(fillProgress) ? PaintingStyle.fill: PaintingStyle.stroke;
    //  : 
    double arcAngle = (2 * math.pi) * (percent/100);
    if(percent == 100 && fillProgress){
      arcAngle = (2 * math.pi) * 0.99;
    }

    
    if(fillProgress){

      Path path = new Path();

      path.moveTo(size.width*0.5,size.height*0.5);
      path.lineTo(size.width*0.5,size.width*0);
      path.arcTo(
        Rect.fromCircle(
          center: center,
          radius: radio,
        ),
        -math.pi/2,
        arcAngle,
        true, 
      );

      if(percent == 100){

      }else{
        path.lineTo(size.width*0.5,size.height*0.5);
      }

      canvas.drawPath(path, arcPainter);

    }else{
      canvas.drawArc(
      Rect.fromCircle(center: center, radius:radio),// Espacio a ubicar el arco
      -math.pi /2, // Angulo de inicio
      arcAngle,
      false,
      arcPainter);
    }


   
  }

  @override
  bool shouldRepaint(_RadialProgress oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_RadialProgress oldDelegate) => false;
}