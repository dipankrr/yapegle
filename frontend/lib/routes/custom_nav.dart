import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:go_router/go_router.dart'; // ✅ for web only

void navigateToRoom(BuildContext context, String roomId) {
  final newUrl = '/room/$roomId';

  // Replace browser history
  html.window.history.replaceState(null, '', newUrl);

  // Trigger GoRouter navigation (doesn't push new history entry)
  context.go(newUrl);
}


void hardNavigateToRoom(String roomId) {
  final newUrl = '#/room/$roomId';

  // Replace the current history entry
  html.window.history.replaceState(null, '', newUrl);

  // Reload the app at the new URL — now it's like a fresh load
  html.window.location.reload();
}
