
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  // final String ageOrWeight;
  final TextEditingController cntrl;
  const CustomTextField({super.key, required this.cntrl,});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child:
      TextFormField(
        controller: widget.cntrl,
        // onChanged: (val){
        //   setState(() {
        //     widget.cntrl.text = val.toString();
        //   });
        // },

        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 40, ),
        cursorHeight: 44, cursorColor: Colors.white,
        //initialValue:weightt,

        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 0),
            //isDense: true,
            fillColor: Colors.white70, filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2)
            )
        ),
      ),
    ) ;
  }
}