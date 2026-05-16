




//correct code 
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:amity_university/ServiceProvider/Presentation/Constants/constant.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Home/EndProcess/AfterPhoto.dart';
// import 'package:amity_university/api_service_baseurl.dart';

// class OtpEntryScreen extends StatefulWidget {
//   final int complaintId;

//   const OtpEntryScreen({
//     super.key,
//     required this.complaintId,
//   });

//   @override
//   State<OtpEntryScreen> createState() => _OtpEntryScreenState();
// }

// class _OtpEntryScreenState extends State<OtpEntryScreen> {
//   final List<TextEditingController> _otpControllers =
//       List.generate(4, (_) => TextEditingController());
//   bool isLoading = false;
//   bool isFetching = true;
//   String phoneNumber = '';
//   String otp = '';

//   @override
//   void initState() {
//     super.initState();
//     generateOtp(); // ✅ generates and fetches OTP on screen load
//   }

//   Future<void> generateOtp() async {
//     final url = Uri.parse('${baseUrl}api/complaints/${widget.complaintId}');
//     try {
//       final response = await http.post(url, headers: {
//         'Content-Type': 'application/json',
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           otp = data['data']['complain_otp'].toString(); // fetched OTP
//           phoneNumber = data['data']['contact'] ?? '';
//           isFetching = false;
//         });
//       } else {
//         throw Exception('Failed to generate OTP');
//       }
//     } catch (e) {
//       debugPrint('❌ Error generating OTP: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to generate OTP')),
//       );
//       setState(() => isFetching = false);
//     }
//   }

//   void _focusNextField(int index, String value) {
//     if (value.isNotEmpty && index < 3) {
//       FocusScope.of(context).nextFocus();
//     }
//   }

//   String getEnteredOtp() {
//     return _otpControllers.map((controller) => controller.text).join();
//   }

//   Future<void> verifyOtp() async {
//     String enteredOtp = getEnteredOtp();
//     if (enteredOtp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Please enter all 4 digits')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);
//     final url = Uri.parse('${baseUrl}api/complaints/verify');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         "complaintId": widget.complaintId,
//         "otp": enteredOtp,
//       }),
//     );

//     setState(() => isLoading = false);

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       if (jsonResponse['success'] == true) {
//         _showVerifiedPopup();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('❌ ${jsonResponse['message']}')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Failed to verify OTP')),
//       );
//     }
//   }

//   void _showVerifiedPopup() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding: const EdgeInsets.all(20),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const CircleAvatar(
//               backgroundColor: ColorPicker.verifyOTP,
//               radius: 30,
//               child: Icon(Icons.check, color: Colors.white, size: 40),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "The OTP you entered is verified.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => AfterPhotoScreen(
//                       complaintId: widget.complaintId,
//                       process: 'before',
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorPicker.blueColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 minimumSize: const Size(double.infinity, 48),
//               ),
//               child: const Text("OK", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOtpBox(int index) {
//     return SizedBox(
//       width: 60,
//       child: TextField(
//         controller: _otpControllers[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: const TextStyle(fontSize: 24),
//         maxLength: 1,
//         decoration: const InputDecoration(
//           counterText: "",
//           border: OutlineInputBorder(),
//         ),
//         onChanged: (value) => _focusNextField(index, value),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: ColorPicker.blueColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: isFetching
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     Image.asset(
//                       'assets/logo.png',
//                       height: 80,
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Enter the OTP sent to your mobile number.",
//                       style: TextStyle(fontSize: 14),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 7),
//                     Text(
//                       phoneNumber,
//                       style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "OTP is: $otp", // ✅ shown for testing only
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: ColorPicker.verifyOTP,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(4, (index) => _buildOtpBox(index)),
//                     ),
//                     const SizedBox(height: 20),
//                     isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: verifyOtp,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ColorPicker.blueColor,
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8)),
//                             ),
//                             child: const Text("Submit",
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white)),
//                           ),
//                     const SizedBox(height: 30),

//                     // 🔴 Removed Resend OTP section below as per your instruction
//                     /*
//                     const Text(
//                       "Did not receive the code?",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                     ),
//                     const SizedBox(height: 10),
//                     OutlinedButton(
//                       onPressed: generateOtp, // ✅ regenerates OTP
//                       style: OutlinedButton.styleFrom(
//                         side:
//                             BorderSide(color: ColorPicker.blueColor, width: 2),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                       ),
//                       child: const Text(
//                         "Resend OTP",
//                         style: TextStyle(
//                           color: ColorPicker.blueColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     */
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:amity_university/ServiceProvider/Presentation/Constants/constant.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Home/EndProcess/AfterPhoto.dart';
// import 'package:amity_university/api_service_baseurl.dart';

// class OtpEntryScreen extends StatefulWidget {
//   final int complaintId;

//   const OtpEntryScreen({
//     super.key,
//     required this.complaintId,
//   });

//   @override
//   State<OtpEntryScreen> createState() => _OtpEntryScreenState();
// }

// class _OtpEntryScreenState extends State<OtpEntryScreen> {
//   final List<TextEditingController> _otpControllers =
//       List.generate(4, (_) => TextEditingController());
//   bool isLoading = false;
//   bool isFetching = true;
//   String phoneNumber = '';
//   String otp = '';

//   @override
//   void initState() {
//     super.initState();
//     generateOtp(); // ✅ generates and fetches OTP on screen load
//   }

//   Future<void> generateOtp() async {
//     final url = Uri.parse('${baseUrl}api/complaints/${widget.complaintId}');
//     try {
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('🔍 API Response: $data');

//         setState(() {
//          otp = data['data'][0]['complain_otp']?.toString() ?? 'N/A';
//         phoneNumber = data['data'][0]['contact']?.toString() ?? 'N/A';
//         isFetching = false;
//         });
//       } else {
//         throw Exception('Failed to generate OTP');
//       }
//     } catch (e) {
//       debugPrint('❌ Error generating OTP: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to generate OTP')),
//       );
//       setState(() => isFetching = false);
//     }
//   }

//   void _focusNextField(int index, String value) {
//     if (value.isNotEmpty && index < 3) {
//       FocusScope.of(context).nextFocus();
//     }
//   }

//   String getEnteredOtp() {
//     return _otpControllers.map((controller) => controller.text).join();
//   }

//   Future<void> verifyOtp() async {
//     String enteredOtp = getEnteredOtp();
//     if (enteredOtp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Please enter all 4 digits')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);
//     final url = Uri.parse('${baseUrl}api/complaints/verify');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         "complaintId": widget.complaintId,
//         "otp": enteredOtp,
//       }),
//     );

//     setState(() => isLoading = false);

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       if (jsonResponse['success'] == true) {
//         _showVerifiedPopup();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('❌ ${jsonResponse['message']}')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Failed to verify OTP')),
//       );
//     }
//   }

//   void _showVerifiedPopup() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         contentPadding: const EdgeInsets.all(20),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const CircleAvatar(
//               backgroundColor: ColorPicker.verifyOTP,
//               radius: 30,
//               child: Icon(Icons.check, color: Colors.white, size: 40),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "The OTP you entered is verified.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => AfterPhotoScreen(
//                       complaintId: widget.complaintId,
//                       process: 'before',
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorPicker.blueColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 minimumSize: const Size(double.infinity, 48),
//               ),
//               child: const Text("OK", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOtpBox(int index) {
//     return SizedBox(
//       width: 60,
//       child: TextField(
//         controller: _otpControllers[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: const TextStyle(fontSize: 24),
//         maxLength: 1,
//         decoration: const InputDecoration(
//           counterText: "",
//           border: OutlineInputBorder(),
//         ),
//         onChanged: (value) => _focusNextField(index, value),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: ColorPicker.blueColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: isFetching
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     Image.asset(
//                       'assets/logo.png',
//                       height: 80,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       "Enter the OTP sent to your mobile number ",
//                       style: const TextStyle(fontSize: 14),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 7),
//                     Text(
//                       phoneNumber,
//                       style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "OTP is: $otp", // ✅ shown for testing only
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: ColorPicker.verifyOTP,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(4, (index) => _buildOtpBox(index)),
//                     ),
//                     const SizedBox(height: 20),
//                     isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: verifyOtp,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ColorPicker.blueColor,
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8)),
//                             ),
//                             child: const Text("Submit",
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white)),
//                           ),
//                     const SizedBox(height: 30),

//                     // 🔴 Resend section was intentionally removed
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
