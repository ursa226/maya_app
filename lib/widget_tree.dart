import 'package:maya_app/auth.dart';
import 'package:maya_app/home_page.dart';
import 'package:maya_app/login.dart';
import 'package:flutter/material.dart';
import 'package:maya_app/dashboard.dart' show MyDash;
import 'package:maya_app/signup.dart' show MySign;

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key?key}) : super (key: key);

  @override
  State<StatefulWidget> createState() => _WidgetTreeState();

}
class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges, builder: (context, snapshot){
      if(snapshot.hasData){
        return const MyDash();
      }
      else {
        return const LoginPage();
      }
    },);
  }
  
}