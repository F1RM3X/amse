import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('About'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(thickness: 1, color: Colors.grey[400], height: 1),
            SizedBox(height: 300),
            Center(child: Text('Developped by Maxence Firmin')),
            SizedBox(
              width: 300,
              child: Center(
                child: Text(
                  'This application was created for the AMSE courses in IMT Nord Europe.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
