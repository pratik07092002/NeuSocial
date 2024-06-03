import 'package:flutter/material.dart';
import 'package:nueusocial/utils/ScreenQuery.dart';

class ShowField extends StatefulWidget {
  const ShowField({super.key, required this.name, required this.value});
  final String name;
  final String value;
  @override
  State<ShowField> createState() => _ShowFieldState();
}

class _ShowFieldState extends State<ShowField> {

  @override
  Widget build(BuildContext context) {
    return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: ScreenQuery.screenWidth(context) * 0.3,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 35, 35, 35),
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors
                                          .purple, // Specify border color here
                                      width:
                                          2.0, // Adjust the border width as needed
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                child:  Column(
                                  children: [
                                    Text(
                                     widget.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height:
                                          ScreenQuery.screenHeight(context) *
                                              0.0075,
                                    ),
                                    Text(
                                      widget.value ,
                                         
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            );
  }
}