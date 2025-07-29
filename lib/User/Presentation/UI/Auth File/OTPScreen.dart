

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
// import 'package:amity_university/api_service_baseurl.dart';

// class OTPScreen extends StatefulWidget {
//   final String mobile;
//   final String pinFromApi;

//   const OTPScreen({
//     super.key,
//     required this.mobile,
//     required this.pinFromApi,
//   });

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   String enteredCode = "";
//   bool isLoading = false;

//   Future<void> verifyOTP() async {
//     if (enteredCode.length != 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a 4-digit PIN")),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("${baseUrl}api/front/login/verify"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "mobile": widget.mobile,
//           "pin": enteredCode,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       debugPrint("📦 Verify API Response: $data");

//       if (response.statusCode == 200 && data['success'] == true && data['user']?['id'] != null) {
//         // ✅ Save user info in SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setInt('userId', data['user']['id']);
//         await prefs.setString('userMobile', data['user']['mobile']);
//         await prefs.setString('userName', data['user']['name'] ?? 'User');
//         await prefs.setString('userImage', data['user']['image'] ?? '');
//         await prefs.setString('userEmail', data['user']['email'] ?? '');
//         await prefs.setString('userAddress', data['user']['address'] ?? '');
//         await prefs.setString('token', data['token']);

//         // // 🖨️ Print user id and token
//         // debugPrint("✅ User ID Saved: ${data['user']['id']}");
//         // debugPrint("✅ Token Saved: ${data['token']}");
//         // debugPrint("👤 User Details: ${data['user']}"); // 👈 prints full user object

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login Successful. User ID: ${data['user']['id']}")),
//         );

//         if (!mounted) return;

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//           (route) => false,
//         );
//       } else {
//         debugPrint("❌ Verify failed: ${data['message']}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? "Invalid PIN")),
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ Error verifying PIN: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error verifying PIN. Please try again.")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Text(
//                 "Verify Mobile Number",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: ColorPicker.logheadColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 decoration: BoxDecoration(
//                   color: ColorPicker.otpsentColorr,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.all(8),
//                 child: Text(
//                   "PIN sent to mobile number ${widget.mobile}",
//                   style: TextStyle(
//                     color: ColorPicker.otpsenttextColorr,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "(PIN is ${widget.pinFromApi})",
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//               const SizedBox(height: 30),
//               OtpTextField(
//                 numberOfFields: 4,
//                 borderColor: const Color(0xFF512DA8),
//                 showFieldAsBox: true,
//                 onSubmit: (String code) {
//                   setState(() {
//                     enteredCode = code;
//                   });
//                 },
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorPicker.logheadColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onPressed: isLoading ? null : verifyOTP,
//                   child: isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Text(
//                           "Verify PIN",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
import 'package:amity_university/api_service_baseurl.dart';

class OTPScreen extends StatefulWidget {
  final String mobile;
  final String pinFromApi;

  const OTPScreen({
    super.key,
    required this.mobile,
    required this.pinFromApi,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String enteredCode = "";
  bool isLoading = false;

  Future<void> verifyOTP() async {
    if (enteredCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 4-digit PIN")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}api/front/login/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobile": widget.mobile,
          "pin": enteredCode,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("📦 Verify API Response: $data");

      if (response.statusCode == 200 && data['success'] == true && data['user']?['id'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', data['user']['id']);
        await prefs.setString('userMobile', data['user']['mobile']);
        await prefs.setString('userName', data['user']['name'] ?? 'User');
        await prefs.setString('userImage', data['user']['image'] ?? '');
        await prefs.setString('userEmail', data['user']['email'] ?? '');
        await prefs.setString('userAddress', data['user']['address'] ?? '');
        await prefs.setString('token', data['token']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful. ")),
        );

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        debugPrint("❌ Verify failed: ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Invalid PIN")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error verifying PIN: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error verifying PIN. Please try again.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Verify Mobile Number",
                style: TextStyle(
                  fontSize: 20,
                  color: ColorPicker.logheadColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: ColorPicker.otpsentColorr,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  "PIN sent to mobile number ${widget.mobile}",
                  style: TextStyle(
                    color: ColorPicker.otpsenttextColorr,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "(PIN is ${widget.pinFromApi})",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 30),
              OtpTextField(
                numberOfFields: 4,
                borderColor: const Color(0xFF512DA8),
                showFieldAsBox: true,
                onSubmit: (String code) {
                  setState(() {
                    enteredCode = code;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPicker.logheadColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isLoading ? null : verifyOTP,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Verify PIN",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
