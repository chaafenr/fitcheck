import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart'; // Import PhoneNumber type
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

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
  // final TextEditingController _activationCodeController = TextEditingController(); // Controller for OTP

  // Validate phone number
  void _validatePhoneNumber(PhoneNumber phone) {
    setState(() {
      isValid = phone.number.length >= 10; // Ensure at least 10 digits
      fullPhoneNumber = phone.completeNumber; // Store full phone number
    });
  }

  Future<void> _checkUser(String phone) async{
    // check if we already have the number in the system 
    final userState = await Amplify.Auth.fetchUserAttributes();
    //This means user is not signed up 
    if(userState.isEmpty){
      //Sign up the user 
      _signUpUser(fullPhoneNumber);
    }else{
      //User is already signed up 
      //Sign in the user 
      _signInUser(fullPhoneNumber, context);
    }
      }

  // Sign up user with the phone number
  Future<void> _signUpUser(String phoneNumber) async {
    try {
      // Auth.signUp sends otp and registers user in cloud 
      final result = await Amplify.Auth.signUp(
        username: phoneNumber,
        password: "TempPassword123!", // Required by Cognito but won’t be used
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.phoneNumber: phoneNumber,
        }),
      );
      // send user to otp page 
      if (!result.isSignUpComplete) {
        debugPrint('OTP sent. User needs to confirm sign-up.');
        Navigator.pushNamed(context, '/otp_verification', arguments: {"phoneNumber": phoneNumber});
      }
    } catch (e) {
      debugPrint('Error sending OTP: $e');
    }
  }


  // // Confirm the OTP code and sign the user in
  // Future<void> _confirmSignUp(String phoneNumber, String otpCode) async {
  //   try {
  //     final result = await Amplify.Auth.confirmSignUp(
  //       username: phoneNumber,
  //       confirmationCode: otpCode,
  //     );

  //     if (result.isSignUpComplete) {
  //       debugPrint('User confirmed! Proceeding to sign in.');
  //       _signInUser(phoneNumber);
  //     }
  //   } catch (e) {
  //     debugPrint('Error confirming OTP: $e');
  //   }
  // }

  // Sign the user in
  Future<void> _signInUser(String phoneNumber, BuildContext context) async {
    try {
      // this signs user in and sends a authorization code 
      final signInResult = await Amplify.Auth.signIn(
        username: phoneNumber,
        options: CognitoSignInOptions(authFlowType: AuthenticationFlowType.customAuth),
      );
      // Step 2: If OTP is required, navigate to OTP verification page
    if (!signInResult.isSignedIn) {
        debugPrint('OTP sent. Redirecting to OTP verification page.');
        Navigator.pushNamed(context, '/otp_verification', arguments: {"phoneNumber": phoneNumber});
      } else {
        debugPrint('User signed in successfully without OTP (unexpected case).');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
    }
  }
  // // Send OTP if the phone number is valid
  // void sendOtp() {
  //   if (isValid) {
  //     _signUpUser(fullPhoneNumber);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Enter a valid phone number!")),
  //     );
  //   }
  // }

  // Dismiss the keyboard
  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
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
                    color: Color(0xff872626),
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
                    fillColor: Color(0xffd0addc),
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
                    // if the number is valid we checl number either sign in user or sign up 
                    onPressed: isValid ? () {
                      _checkUser(fullPhoneNumber);
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid ? Color(0xffd64117) : Colors.grey[700],
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