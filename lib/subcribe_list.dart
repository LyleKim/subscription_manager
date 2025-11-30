import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/rename.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeListScreen extends StatefulWidget{

  const SubscribeListScreen({super.key});

  @override
  State<SubscribeListScreen> createState() => SubscribeListScreenState();
}

class SubscribeListScreenState extends State<SubscribeListScreen>{
  final supabase = Supabase.instance.client;

  List<String> platformList = [];
  bool isLoading = true;

  String username = "";

  

  Future<void> loadPlatform() async{
    final user = supabase.auth.currentUser;

    if(user == null){
      return;
    }

    final userdata = await supabase
    .from('users')
    .select('username')
    .eq('user_id', user.id)
    .single();
    
    username = userdata['username'] as String;

    final data = await supabase
    .from('subscribe_info')
    .select('platforms(name)')
    .eq('user_id', user.id);

    if(data.isEmpty){
      print("No Subscribe");
      return;
    }

    final platforms = data
    .map((e)=>e['platforms']?['name'])
    .where((n)=>n!=null)
    .cast<String>()
    .toList();


    setState(() {
      platformList = platforms;
      isLoading = false;
    });
    
  }

  @override
  void initState(){
    super.initState();
    loadPlatform();
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("My Platforms")),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        :Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(username),

            const SizedBox(height : 20),

            Expanded( 
              child: ListView.builder(
              itemCount: platformList.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(platformList[index].toString()),
                );
              },
              ),
            ),

            const SizedBox(height : 20),

            Row(
              children:[

                ElevatedButton(
                  onPressed: () async{
                    supabase.auth.signOut();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=>LogInScreen()
                      )
                    );
                  }, 
                  child: const Text("Log Out")
                ), 

                ElevatedButton(
                  onPressed: () async{

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=>RenameScreen()
                      )
                    );
                  }, 
                  child: const Text("Rename")
                ), 
              ]
            )      
          ]
        )
        )
    );
  }
}