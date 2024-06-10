import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedCommunitiesScreen extends StatefulWidget {
  @override
  _SelectedCommunitiesScreenState createState() => _SelectedCommunitiesScreenState();
}

class _SelectedCommunitiesScreenState extends State<SelectedCommunitiesScreen> {
  Future<Set<String>> _getSelectedCommunities() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final selectedCommunities = keys.where((key) => prefs.getBool(key) ?? false).toSet();
    return selectedCommunities;
  }

  Future<void> _deleteCommunity(String community) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(community);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Homebackground1.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Selected Communities' , style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<Set<String>>(
          future: _getSelectedCommunities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No communities selected'));
            } else {
              final selectedCommunities = snapshot.data!;
              return ListView.builder(
                itemCount: selectedCommunities.length,
                itemBuilder: (context, index) {
                  final community = selectedCommunities.elementAt(index);
                  return ListTile(
                    title: Text(community , style: TextStyle(color: Colors.white),),
                    trailing: IconButton(
                      icon: Icon(Icons.delete , color: Colors.white,),
                      onPressed: () {
                        _deleteCommunity(community);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
