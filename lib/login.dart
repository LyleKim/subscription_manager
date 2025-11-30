import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:flutter_application_1/subcribe_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInScreen extends StatefulWidget{
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => LogInScreenState();
}

class LogInScreenState extends State<LogInScreen>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  String _message = "";

  Future<void> LogIn() async{
    try{
      final response = await supabase.auth.signInWithPassword(
        email : _emailController.text,
        password: _passwordController.text
      );

      final user = response.user;

      if(user == null){
        setState(() {
          _message = "Log In Failed : No User";
        });
      }
      else{

        // final userdata = await supabase
        // .from('users')
        // .select('username')
        // .eq('user_id', user.id)
        // .single();
      

        // final username = userdata['username'];

        if(!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=>SubscribeListScreen()
          )
        );
      }
    }catch(e){
      setState(() {
        _message = "Log In Failed : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title : const Text("LogIn Screen")),
      body : Padding(
        padding : const EdgeInsets.all(20),
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller : _emailController,
              decoration: const InputDecoration(
                labelText : "Email",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height : 10),

            TextField(
              controller : _passwordController,
              decoration: const InputDecoration(
                labelText : "Password",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: LogIn, 
                    child: const Text("Log In")
                    )
                ),

                Expanded(
                  child:ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>const SignUpScreen())
                      );
                    }, 
                    child: const Text("Sign Up"))
                )
              ],


            ),

            const SizedBox(height: 20),

            Text(
              _message,
              style: const TextStyle(color: Colors.blue)
            )

          ],
        ),
      ),
    );
  }

}