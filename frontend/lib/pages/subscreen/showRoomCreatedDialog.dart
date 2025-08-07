import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/routes/custom_nav.dart';
import 'package:frontend/services/socket_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void showRoomCreatedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (context) {
      return Consumer<SocketService>(
builder: (context, prov, child) {
return Dialog(
  backgroundColor: Colors.green[900], // Dark green background
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Stack(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Column(
              children: [
                Text(
                  'Room Created',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text on dark background
                  ),
                ),
                Text(
                  prov.roomId,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text on dark background
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Link box and COPY button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green[800],
                border: Border.all(color: Colors.greenAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      prov.roomId,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: prov.roomId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link copied!')),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.greenAccent,
                    ),
                    child: Text('COPY'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Big green "Go to Room" button
            GestureDetector(
              onTap: () {
               // prov.joinRoom(prov.roomId);
                // Navigate to room logic
                //context.go('/room/${prov.roomId}');
                hardNavigateToRoom(prov.roomId);

              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Enter room',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Close button in top-right
      Positioned(
        top: 8,
        right: 8,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, color: Colors.white),
        ),
      ),
    ],
  ),
);
},
);

    },
  );
}
