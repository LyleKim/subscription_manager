import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/subcribe_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RenameScreen extends StatefulWidget{
  const RenameScreen({super.key});

  @override
  State<RenameScreen> createState() => RenameScreenState();
}

class RenameScreenState extends State<RenameScreen>{
  final renameController = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> Rename() async{
    final user = supabase.auth.currentUser;

    if(user != null){
      try{
        final user_id = user.id;

        await supabase
        .from('users')
        .update({'username': renameController.text.trim()})
        .eq('user_id', user_id);
      }catch(e){
        print("Log In Failed : $e");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
           builder: (context)=>SubscribeListScreen()
        )
      );

    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title : const Text("Rename Screen")),
      body : Padding(
        padding : const EdgeInsets.all(20),
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller : renameController,
              decoration: const InputDecoration(
                labelText : "New Name",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: Rename, 
              child: const Text("Rename")
            ),
          ]
        )
      )
    );
  }
}