import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/CommunityDisplay/Community_Profile_Screen.dart';
import 'package:nueusocial/SearchComunity/bloc/search_com_bloc.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/enums/Statusscreen.dart';
import 'package:nueusocial/widgets/customtextform.dart';

class SearchCommunity extends StatelessWidget {
  final UserModel usermod;
  final User firebaseuser;

  SearchCommunity({super.key, required this.usermod, required this.firebaseuser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchComBloc()..add(SearchUpdateevent()),
      child: SearchCommunityBody(firebaseuser: firebaseuser , usermod: usermod,),
    );
  }
}

class SearchCommunityBody extends StatefulWidget {
    final UserModel usermod;
  final User firebaseuser;

  SearchCommunityBody({super.key, required this.usermod, required this.firebaseuser});
  @override
  _SearchCommunityBodyState createState() => _SearchCommunityBodyState();
}

class _SearchCommunityBodyState extends State<SearchCommunityBody> {
  TextEditingController _searchcontroller = TextEditingController();

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchComBloc, SearchComState>(
      builder: (context, state) {
        switch (state.status) {
          case Statuss.loading:
            return Center(child: CircularProgressIndicator());
          case Statuss.failure:
            return Center(child: Text("Error"));
          case Statuss.success:
            return Scaffold(
              appBar: AppBar(automaticallyImplyLeading: true , backgroundColor: Colors.black, iconTheme: IconThemeData(color: Colors.white), title: Text("Join Communities" , style: TextStyle(color: Colors.white),),),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Homebackground1.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextForm(
                          hinttext: "Search For Communities...",
                          prefixicon: Icon(Icons.search),
                          obscure: false,
                          controller: _searchcontroller,
                         
                          onChanged: (value) => context.read<SearchComBloc>().add(TextFieldSearch(SearchText: value)),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.TempComList.length,
                          itemBuilder: (context, index) {
                            final item = state.TempComList[index];
                            return ListTile(
                              title: Text(item.name.toString() , style: TextStyle(color: Colors.white),),
                              subtitle: Text(item.Type.toString() , style: TextStyle(color: Colors.white),),
                              trailing: Text(item.ComStatus.toString() , style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
  backgroundImage: getImageProvider(item.Profilepic)
       
),
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityDisplay(userCredential: widget.firebaseuser , usermod: widget.usermod, communityModel: item ),)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
   ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage("assets/profilecom.jpg");
    }
  }
}


