import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>{

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final supabase = Supabase.instance.client;

  String _message = "";

  Future<void> signUp() async{
    try{
      final authResponse = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = authResponse.user;

      if(user == null){
        setState(() => _message = "Sign Up Failed : Not User Data");
        return;
      }

      final userid = user.id;

      await supabase.from('users').insert({
        'user_id' : userid,
        'email' : _emailController.text.trim(),
        'username' : _nameController.text.trim(), 
      });

      setState(() => _message = "Sign Up Success");
    }
    catch(e){
      setState(() => _message = "Sign Up Failed : $e");
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: signUp, 
              child: const Text("Sign Up")
            ),

            const SizedBox(height: 20),

            Text(_message)
        
          ],
        ),)
    );
  }
}