import 'package:flutter/material.dart';
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

  Future<void> loadPlatform() async{
    final user = supabase.auth.currentUser;

    if(user == null){
      return;
    }

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
        :ListView.builder(
          itemCount: platformList.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(platformList[index].toString()),
            );
          },
        )
    );
  }
}