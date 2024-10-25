
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/authentication.dart';
import 'HomeScreen.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtEmail = TextEditingController();
    TextEditingController txtPwd = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: txtEmail,
              decoration: InputDecoration(
                hintText: 'Email Id',
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: txtPwd,
              decoration: InputDecoration(

                hintText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () async {
              String status = await GoogleAuthService.googleAuthService
                  .createAccount(txtEmail.text, txtPwd.text);
              if(status=='Success')
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
              }
            },
            child:Container(
              height: 60,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:  Colors.purple,),
              child: Center(
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
