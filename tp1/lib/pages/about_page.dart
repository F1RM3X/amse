import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    

  

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('About'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Developped by Maxence Firmin')),
            Center(child: Text('This application was created for the AMSE courses in IMT Nord Europe.'))
          ],
        ),
      ),
    );
  }
}