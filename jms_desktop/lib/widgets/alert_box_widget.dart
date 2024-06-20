import 'package:flutter/material.dart';

class AlertBoxWidgets {
  AlertBoxWidgets();

  void showAlert(
      BuildContext context, String title, String content, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
                color: Color.fromARGB(179, 0, 0, 0),
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: color,
          elevation: 10,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
