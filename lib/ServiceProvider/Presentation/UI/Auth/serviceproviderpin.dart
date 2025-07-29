


// import 'dart:convert';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Serviceproviderhome.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/User/Presentation/UI/Home/Home.dart';

// class ServiceProviderOTPScreen extends StatefulWidget {
//   final String mobile;

//   const ServiceProviderOTPScreen({
//     super.key,
//     required this.mobile,
//   });

//   @override
//   State<ServiceProviderOTPScreen> createState() => _ServiceProviderOTPScreenState();
// }

// class _ServiceProviderOTPScreenState extends State<ServiceProviderOTPScreen> {
//   String enteredCode = "";
//   String backendPin = ""; // ✅ Fetched PIN from backend
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchPinFromBackend();
//   }

//   Future<void> fetchPinFromBackend() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.0.19:3000/api/front/staff-login/request"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"mobile": widget.mobile}),
//       );

//       final data = jsonDecode(response.body);
//       debugPrint("📦 PIN Fetch Response: $data");

//       if (response.statusCode == 200 && data['pin'] != null) {
//         setState(() {
//           backendPin = data['pin'].toString();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? "Failed to fetch PIN")),
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching PIN: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Network error while fetching PIN")),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

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
//         Uri.parse("http://192.168.0.19:3000/api/front/staff-login/verify"), // ✅ Updated verify API
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "mobile": widget.mobile,
//           "pin": enteredCode,
//         }),
//       );

//       final data = jsonDecode(response.body);
//       debugPrint("📦 Verify API Response: $data");

//       if (response.statusCode == 200 && data['success'] == true && data['user']?['id'] != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setInt('userId', data['user']['id']);
//         await prefs.setString('token', data['token']);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Login Successful")),
//         );

//         if (!mounted) return;

//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) =>ServiceProviderHomeScreen()),
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
//               if (backendPin.isNotEmpty)
//                 Text(
//                   "(PIN is $backendPin)", // 📝 Display fetched PIN for testing
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
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
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Serviceproviderhome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/api_service_baseurl.dart'; 

class ServiceProviderOTPScreen extends StatefulWidget {
  final String mobile;

  const ServiceProviderOTPScreen({
    super.key,
    required this.mobile,
  });

  @override
  State<ServiceProviderOTPScreen> createState() =>
      _ServiceProviderOTPScreenState();
}

class _ServiceProviderOTPScreenState extends State<ServiceProviderOTPScreen> {
  String enteredCode = "";
  String backendPin = ""; // ✅ Fetched PIN from backend
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPinFromBackend();
  }

  Future<void> fetchPinFromBackend() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}api/front/staff-login/request"), // ✅ Using baseUrl
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": widget.mobile}),
      );

      final data = jsonDecode(response.body);
      debugPrint("📦 PIN Fetch Response: $data");

      if (response.statusCode == 200 && data['pin'] != null) {
        setState(() {
          backendPin = data['pin'].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Failed to fetch PIN")),
        );
      }
    } catch (e) {
      debugPrint("❌ Error fetching PIN: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error while fetching PIN")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
        Uri.parse("${baseUrl}api/front/staff-login/verify"), // ✅ Using baseUrl
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobile": widget.mobile,
          "pin": enteredCode,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("📦 Verify API Response: $data");

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['user']?['id'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        /// ✅ Save staffId, token, and staffName
        await prefs.setInt('staffId', data['user']['id']); // 👈 staffId
        await prefs.setString('token', data['token']);
        await prefs.setString('staffName', data['user']['name'] ?? '');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful")),
        );

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ServiceProviderHomeScreen()),
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
              if (backendPin.isNotEmpty)
                Text(
                  "(PIN is $backendPin)", // 📝 Display fetched PIN for testing
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
