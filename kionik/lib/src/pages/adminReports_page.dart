import 'package:flutter/material.dart';
import 'package:kionik/src/components/circularGraph_widget.dart';
import 'package:kionik/src/components/static_widgets.dart';
import 'package:kionik/src/services/database_service.dart';

class AdminReportPage extends StatefulWidget {
  static final route = "adminReport";
  @override
  _AdminReportPageState createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  DateTime date = DateTime.now();

  String dateSearch;

  String uidEmployer = 'none';

  bool _search = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Informes'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: _buildBody(size),
    );
  }

  Widget _buildBody(Size size) {
    return ListView(
      children: <Widget>[
        _buildSelector(size),
        buildButton(
            size,
            'Selecciona fecha',
            (uidEmployer != 'none')
                ? () {
                    _selectDate(context);
                  }
                : null),
        (_search) ? _buildProgressInfo(size) : Container(),
      ],
    );
  }

  Widget _buildSelector(Size size) {
    return FutureBuilder(
        future: DatabaseService().getEmployers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<DropdownMenuItem<dynamic>> items = new List();
          items.add(
              _buildItem(size, {"name": "Seleccione un empleado"}, 'none'));
          if (snapshot.hasData) {
            final Map body = snapshot.data['body'];
            body.forEach((id, item) {
              items.add(_buildItem(size, item, id));
            });
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.deepOrange)),
              margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: 10.0),
              child: DropdownButton(
                items: items,
                value: uidEmployer,
                isExpanded: true,
                underline: Container(),
                onChanged: (v) {
                  setState(() {
                    uidEmployer = v;
                  });
                },
              ),
            );
          } else {
            return buildLoading(size);
          }
        });
  }

  Widget _buildItem(Size size, Map body, String id) {
    return DropdownMenuItem(
      value: id,
      child: Text(body['name']),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2021));
    if (date != null) {
      setState(() {
        dateSearch = date.toString().split(' ')[0];
        _search = true;
      });
    } else {}
  }

  Widget _buildProgressInfo(Size size) {
    return FutureBuilder(
        future: DatabaseService().getProgress(uidEmployer, dateSearch),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['resolve']) {
              final data = snapshot.data['body'];

              return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Progreso',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        buildLabel('Día: ', size),
                        Text(
                          dateSearch,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    _buildGraph(size, data['rolId'], data['progress']),
                    buildLabel('Evidencias: ', size),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FadeInImage(
                        width: 200.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/png/loading.png'),
                        image: NetworkImage(data['evidence']),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              if (snapshot.data['statusCode'] == 999) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildLabel('No hay progreso registrado', size),
                    ],
                  ),
                );
              } else {
                return buildLoading(size);
              }
            }
          } else {
            return buildLoading(size);
          }
        });
  }

  Widget _buildGraph(Size size, String rolId, String progress) {
    int rest = 0;
    int over = 0;
    double percent = 0.0;
    bool _cumplido = false;
    bool _over = false;

    return FutureBuilder(
      future: DatabaseService().getRol(rolId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final Map body = snapshot.data['body'];

          percent =
              (double.parse(progress) / double.parse(body['roleGoal'])) * 100;
          if (percent == 100.0 || percent > 100.0) {
            _cumplido = true;
            final prog = int.parse(progress);
            final goal = int.parse(body['roleGoal']);
            over = prog - goal;
            if (over > 0) {
              _over = true;
            }
          } else {
            _cumplido = false;
            final prog = int.parse(progress);
            final goal = int.parse(body['roleGoal']);
            rest = goal - prog;
          }
          final Widget overW = Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Adicional: ',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Text(
                  over.toString(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )
              ],
            ),
          );

          final Widget restW = Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Faltante: ',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Text(
                  rest.toString(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              ],
            ),
          );
          final Widget done = Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Objetivo Cumplido',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )
              ],
            ),
          );

          final Widget unDone = Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Objetivo por cumplir',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              ],
            ),
          );

          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                width: size.width * 0.5,
                height: size.width * 0.5,
                child: CircularGraphWidget(
                  percent: percent,
                  label: true,
                  labelColor: Colors.black54,
                  labelSize: 40.0,
                  fill: true,
                  fillProgress: false,
                  progressWidth: 20.0,
                  roadWidth: 10.0,
                  progressColor: (_cumplido)?Colors.green:Colors.deepOrange,
                  roadColor: Colors.white,
                ),
              ),
              Row(
                children: <Widget>[
                  buildLabel('Objetivo: ', size),
                  Text(
                    body['roleGoal'],
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  buildLabel('Objetivo: ', size),
                  Text(
                    progress,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              (_cumplido) ? done : unDone,
              SizedBox(
                height: 5.0,
              ),
              (_cumplido) ? Container() : restW,
              (_over) ? overW : Container(),
            ],
          );
        } else {
          return buildLoading(size);
        }
      },
    );
  }
}
