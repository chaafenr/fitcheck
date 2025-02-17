import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart'; // Import PhoneNumber type


class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isValid = false;
  String fullPhoneNumber = ""; // Stores full phone number

  // ✅ Fix: Accept `PhoneNumber` instead of `String`
  void _validatePhoneNumber(PhoneNumber phone) {
    setState(() {
      isValid = phone.number.length >= 10; // Ensure at least 10 digits
      fullPhoneNumber = phone.completeNumber; // Store full phone number
    });
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  void sendOtp() {
    if (isValid) {
      Navigator.pushReplacementNamed(
        context,
        "/otp",
        arguments: {"phoneNumber": fullPhoneNumber}, // ✅ Pass full phone number
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor:Color(0xFFEADCf0),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Center(
                  child: Image.asset(
                    'assets/FitCheck.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "What's your phone number?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Fix: Use `PhoneNumber` in `onChanged`
                IntlPhoneField(
                  controller: phoneController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onChanged: _validatePhoneNumber, // ✅ Fix: Pass correct type
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialCountryCode: 'US',
                ),

                const SizedBox(height: 10),

                // Terms & Privacy Policy
                const Text.rich(
                  TextSpan(
                    text: "By continuing, you agree to our ",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // **Send Verification Button**
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isValid ? sendOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid ? Colors.blue : Colors.grey[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Verification Code',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
