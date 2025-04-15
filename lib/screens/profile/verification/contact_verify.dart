import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ristey/common/custom_button_2.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/navigation/service/support_service.dart';

class ContactVerify extends StatefulWidget {
  const ContactVerify({super.key});

  @override
  State<ContactVerify> createState() => _ContactVerifyState();
}

class _ContactVerifyState extends State<ContactVerify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _sendOTP() async {
    String phoneNumber = userSave.phone??"";
        SupprotService().deletesendlink(
            email: userSave.email!, value: "OTP Verify");
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    // Ensure phone number is in E.164 format (e.g., +919876543210)
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber'; // Adjust country code as needed
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (e.g., on Android with SMS retrieval)
          await _auth.signInWithCredential(credential);
          // _showSuccessDialog();
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // setState(() {
          //   _verificationId = verificationId;
          //   _otpSent = true;
          // });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent successfully')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // _verificationId = verificationId;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.1,
          
          ),
          Center(
            child: Image.asset("images/contactverify.png"),
          ),
          SizedBox(height: 20,),

          Text("Contact Number \n Verification \n Required",style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
          SizedBox( height: Get.height * 0.17,),
          GestureDetector(
            onTap: _sendOTP,
            child: CustomButtom(text: "Verify now",))

        ],
      ),
    );
  }
}