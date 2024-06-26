import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/homescreen/botomnav/botomnav.dart';
import 'package:nueusocial/selectcommunity/bloc/selectcom_bloc.dart';
import 'package:nueusocial/selectcommunity/bloc/selectcom_event.dart';
import 'package:nueusocial/selectcommunity/bloc/selectcom_state.dart';

class SelectCommunityScreen extends StatelessWidget {
   final User usercred;
  final UserModel Usermod;
  const SelectCommunityScreen ({super.key, required this.usercred, required this.Usermod});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectcomBloc() , 
      child: SelectCommunityScreenView(Usermod: Usermod, usercred: usercred,),
    );
  }
}


class SelectCommunityScreenView extends StatelessWidget {
   final User usercred;
  final UserModel Usermod;

  SelectCommunityScreenView({required this.usercred, required this.Usermod});
 

  final List<String> communities = [
    'Sports',
    'Cinema',
    'Music',
    'Football',
    'Tennis',
    'Cricket'
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SelectcomBloc>(context);
    
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Select Community' , style: TextStyle(color: Colors.white),),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your interests',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'NeuSocial has communities for thousands of topics.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: communities.map((community) {
                      return BlocBuilder<SelectcomBloc, SelectcomState>(
                        builder: (context, state) {
                          final isSelected =
                              state.selectedCommunities.contains(community);
                          return ElevatedButton(
                            onPressed: () {
                              bloc.add(
                                  ToggleCommunitySelection(community));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: isSelected
                                  ? Colors.purple.shade100
                                  : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              community,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    SizedBox(width: 16),
                    BlocBuilder<SelectcomBloc, SelectcomState>(
                      builder: (context, state) {
                        if (state.isSkipButtonVisible) {
                          return ElevatedButton(
                            onPressed: () {
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BotoomNav(userCredential: usercred, userMod: Usermod ,) ));
                            },
                            child: Text('Next'),
                          );
                        } else {
                          return Container(); 
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  
  }
}
