import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueusocial/CreateCommunityScreen/model/CommunityModel.dart';
import 'package:nueusocial/Create_Event_Screen/model/eventmodel.dart';
import 'package:nueusocial/createaccount/model/usermodel.dart';
import 'package:nueusocial/main.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';
import 'package:nueusocial/widgets/customtextform.dart';

class CreateEventScreen extends StatefulWidget {
  final UserModel usermod;
  final CommunityModel communityModel;
  final User firebaseuser;
  const CreateEventScreen({super.key, required this.usermod, required this.communityModel, required this.firebaseuser});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
DateTime _datetimestart = DateTime.now();
DateTime _datetimeend = DateTime.now();

TextEditingController _eventnamecontroller = TextEditingController();
TextEditingController _eventdesccontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel , color: Colors.white,),
        ),
        title: Text('Create Event' , style: TextStyle(color: Colors.purple.shade100),),
        actions: [
          IconButton(
            onPressed: () {
              
              String EventName = _eventnamecontroller.text;
              String Eventdesc = _eventdesccontroller.text;

              EventModel eventmod = EventModel(
                CreatedOn: DateTime.now(),
                StartDate: _datetimestart , 
                EndDate: _datetimeend , 
                desc: Eventdesc , 
                name: EventName  , 
              EventId: uuid.v1()
              );

              FirebaseFirestore.instance.collection("Communities").doc(widget.communityModel.ComId).collection("EventHistory").doc(eventmod.EventId).set(eventmod.toMap());
  Navigator.pop(context);

            },
            icon: Icon(Icons.send , color: Colors.purple,),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(height: ScreenQuery.screenHeight(context)*0.05 ),
              CustomTextForm(hinttext: "Event Name", prefixicon: Icon(Icons.event), obscure: false,
               controller: _eventnamecontroller, maxlines: 1, maxkength: 20),
               Container(
                height: ScreenQuery.screenHeight(context)*0.4,
                width: ScreenQuery.screenWidth(context),
                 child: TextFormField(
                  controller: _eventdesccontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none , 
                    hintText: "Description..." ,
                    hintStyle: TextStyle(color: Colors.white)
                  ),
                  maxLines: null,
                 ),
               ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){
                showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2028) ).then((value) {
         setState(() {
           _datetimestart = value!;
         });               
                } );
              }, child: Text("Start Date")) , 
        
              Text("${_datetimestart.day}/${_datetimestart.month}/${_datetimestart.year}",) 
                ],
              ) , 
        
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){
                showDatePicker(context: context, firstDate: _datetimestart, lastDate: DateTime(2028) ).then((value) {
         setState(() {
          if(value != null){
        
           _datetimeend = value;
        
          }
         });               
                } );
              }, child: Text("End Date")) , 
        
              Text("${_datetimeend.day}/${_datetimeend.month}/${_datetimeend.year}",) 
                ],
              ) , 

              
            ],
          ),
        ),
      ),
    );
  }
}

