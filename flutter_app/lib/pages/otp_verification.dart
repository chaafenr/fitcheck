import 'package:flutter/material.dart';
import 'phone_login.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});
  // Confirm the OTP code and sign the user in
  // Controller for OTP input
  final TextEditingController _otpController = TextEditingController();

  // Confirm the OTP code and sign the user in
  Future<void> _confirmSignUp(BuildContext context, String phoneNumber, String otpCode) async {
    try {
      SignUpResult result = await Amplify.Auth.confirmSignUp(
        username: phoneNumber,
        confirmationCode: otpCode,
      );

      if (result.isSignUpComplete) {
        // Navigate to home page if sign up is complete
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        // Handle the case where sign up is not complete
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up not complete. Please try again.')),
        );
      }
    } on AuthException catch (e) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String phoneNumber = args?["phoneNumber"] ?? "your number";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the code',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xffd64117)),
              ),
              const SizedBox(height: 10),
              Text(
                'We sent a code to $phoneNumber',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff872626)),
              ),
              const SizedBox(height: 40),

              // OTP Input
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffd0addc),
                  hintText: 'Enter OTP',
                  hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  // Get OTP from TextField
                  String otpCode = _otpController.text.trim(); 
                  if (otpCode.isNotEmpty) {
                    // Call the _confirmSignUp method with the context and OTP
                    _confirmSignUp(context, phoneNumber, otpCode);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter the OTP.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff872626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Verify & Continue",
                    style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}