import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/form.dart';
import 'package:frontend/pages/subscreen/showRoomCreatedDialog.dart';
import 'package:frontend/services/socket_service.dart';
import 'package:frontend/utils/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
return Consumer<SocketService>(
builder: (context, prov, child) {
return
  Scaffold(
    body:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // CustomTextField(cntrl: TextEditingController()),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: SizedBox(
              height: 300, width: min(screenWidth, 300 ),
              child: Card(
                color: AppColors.card,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        prov.connectToServer();
                        // context.go('/room/:roomId');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: 60, width: double.infinity,
                          child: Card(
                            color: AppColors.buttonPrimary,
                            child: Center(child: Text('Join random chat')),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        prov.connectToServer();
                        prov.createRoom(true);
                        showRoomCreatedDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: 60, width: double.infinity,
                          child: Card(
                            color: AppColors.buttonPrimary,
                            child: Center(child: Text('Create custom room')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    appBar: AppBar(
      title: Text('yapegle', style: TextStyle(color: AppColors.textPrimary),),
    ),
  );
},
);

  }
}