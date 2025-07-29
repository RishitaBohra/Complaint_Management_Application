


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; 
// import 'package:amity_university/User/Presentation/UI/Auth%20File/OTPScreen.dart';
// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/api_service_baseurl.dart'; 

// class Loginscreen extends StatefulWidget {
//   const Loginscreen({super.key});

//   @override
//   State<Loginscreen> createState() => _LoginscreenState();
// }

// class _LoginscreenState extends State<Loginscreen> {
//   final TextEditingController phoneController = TextEditingController();
//   bool isLoading = false;

//   Future<void> loginWithPhone() async {
//     String phone = phoneController.text.trim();

//     if (phone.isEmpty || phone.length != 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a valid 10-digit mobile number")),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse("${baseUrl}api/front/login/request"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"mobile": phone}),
//       );

//       final data = jsonDecode(response.body);
//       debugPrint("📦 Login API Response: $data");

//       if (response.statusCode == 200 && data['pin'] != null) {
//         // ✅ Save mobile number to SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('loggedInMobile', data['mobile']);
//         debugPrint("✅ Saved loggedInMobile: ${data['mobile']}");

//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => OTPScreen(
//               mobile: data['mobile'],
//               pinFromApi: data['pin'].toString(),
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? "Failed to generate PIN")),
//         );
//       }
//     } catch (e) {
//       debugPrint("❌ Login Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Network error. Please try again.")),
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
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Image.asset('assets/logo.png', height: 100),
//                   const SizedBox(height: 10),
//                   Text(
//                     "Login with Mobile Number",
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: ColorPicker.logheadColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: const Text(
//                       "Mobile Number",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: phoneController,
//                     maxLength: 10,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       hintText: "Enter mobile number",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorPicker.logheadColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       onPressed: isLoading ? null : loginWithPhone,
//                       child: isLoading
//                           ? const CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white)
//                           : const Text(
//                               "GENERATE PIN",
//                               style: TextStyle(fontSize: 16, color: Colors.white),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amity_university/User/Presentation/UI/Auth%20File/OTPScreen.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/api_service_baseurl.dart';
import 'package:amity_university/User/Presentation/UI/Home/Home.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> loginWithPhone() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit mobile number")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${baseUrl}api/front/login/request"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": phone}),
      );

      final data = jsonDecode(response.body);
      debugPrint("📦 Login API Response: $data");

      if (response.statusCode == 200 && data['pin'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInMobile', data['mobile']);
        await prefs.setString('role', 'user');
        debugPrint("✅ Saved loggedInMobile: ${data['mobile']}");

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(
              mobile: data['mobile'],
              pinFromApi: data['pin'].toString(),
            ),
          ),
        );
      } else if (response.statusCode == 200 && data['already_logged_in'] == true) {
        // If user is already logged in, navigate directly to Home
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInMobile', data['mobile']);
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Failed to generate PIN")),
        );
      }
    } catch (e) {
      debugPrint("❌ Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', height: 100),
                  const SizedBox(height: 10),
                  Text(
                    "Login with Mobile Number",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorPicker.logheadColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Mobile Number",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter mobile number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      onPressed: isLoading ? null : loginWithPhone,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white)
                          : const Text(
                              "GENERATE PIN",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
