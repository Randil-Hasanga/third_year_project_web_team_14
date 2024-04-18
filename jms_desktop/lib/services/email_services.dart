import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';

class EmailService {
  final serviceID = "service_1un6rrh";
  final templateID = "template_1u4lrxw";
  final publicKey = "qP1AIEXUXjj4wmILR";
  final privateKey = "erU8nuiHf2Zt3SLDF1VAx";

  EmailService();

  Future<void> sendEmail(
      List<String> emails, String subject, String body) async {
    try {
      for (String email in emails) {
        Map<String, dynamic> templateParams = {
          'body': body,
          'subject': subject,
          'to_email': email, // Move this line inside the loop
        };

        await EmailJS.send(
          serviceID,
          templateID,
          templateParams,
          Options(
            publicKey: publicKey,
            privateKey: privateKey,
          ),
        );
        print('Email sent to $email');
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
