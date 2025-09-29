import 'package:flutter/material.dart';
import 'package:test_project/view/screen_one_view.dart';
import 'package:test_project/view/screen_two/login_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0
        ),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenOneView()));
            }, child: Text("Screen One Task")),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginView()));
            }, child: Text("Screen Two Task"))
          ],
        ),
      ),
    );
  }
}